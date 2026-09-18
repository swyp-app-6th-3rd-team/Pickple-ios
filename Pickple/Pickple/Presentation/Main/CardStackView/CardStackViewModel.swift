//
//  CardStackViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

// 타입(찬반/AB)별로 독립적으로 관리하는 카드 상태 — 탭을 오가도 서로 진행 상태가 안 섞인다.
// pending: 서버에서 받아왔지만 아직 화면에 보여준 적 없는 카드.
// history: 뒤로가기 전용 스택(LIFO) — 가장 최근에 넘긴 카드부터 popLast()로 꺼낸다.
// recyclePool: 콘텐츠 소진(hasNext=false) 시 순환 재활용 전용 — history와 별개로 독립
// 운영한다. 처음엔 이 둘을 history 하나로 같이 썼는데(뒤로가기는 popLast, 재활용은
// removeFirst), 같은 배열을 서로 다른 용도로 양쪽에서 파먹다 보니 voteCardData에 카드
// id가 중복되는 버그가 생겼다 — 용도별로 완전히 분리해서 재활용 쪽은 "지금 화면에 이미
// 떠 있는 카드는 절대 안 고른다"는 조건 하나로 안전하게 만든다.
// displayed: 이 타입이 화면에 없는 동안(다른 탭을 보는 동안) 보관해두는 스택 스냅샷 —
// 다시 이 탭으로 돌아왔을 때 그대로 복원한다.
private struct CardBuffer {
    var pending: [VoteCard] = []
    var history: [VoteCard] = []
    var recyclePool: [VoteCard] = []
    var displayed: [VoteCard] = []
    var cursor: String?
    var hasNext = false
}

// buffers/voteCardData를 여러 곳(스와이프 제스처, fetchCards 완료 콜백)에서 건드리는데,
// fetchCards await 이후 재개 지점이 메인 스레드라는 보장이 없어서 빠르게 연속 스와이프하면
// 메인 스레드와 그 재개 지점이 동시에 buffers를 건드려 상태가 깨지는 레이스가 있었다.
// 클래스 전체를 MainActor로 묶으면 init까지 격리돼서(MainView 등의 기본 파라미터값처럼
// 비격리 컨텍스트에서 CardStackViewModel()을 만드는 곳이 깨진다) buffers/voteCardData를
// 실제로 건드리는 메서드에만 개별로 @MainActor를 붙인다.
@Observable
class CardStackViewModel {
    private var voteCardRepository: VoteCardRepository
    private let userInfoRepository: UserInfoRepository

    private var buffers: [VoteType: CardBuffer] = [.forAgainst: CardBuffer(), .ab: CardBuffer()]
    private var currentType: VoteType = .forAgainst
    private var isFetchingMore = false
    // 화면(ZStack)에 동시에 그려서 스와이프 가능한 카드 수 — 현재 카드 1장 + 다음 카드 2장.
    // 넘긴 카드는 뒤로 순환시키지 않고 history로 옮기고, pending에서 새 카드를 하나 당겨와
    // 이 수를 유지한다. 너무 많이 쌓아두면(예전 무한 순환 방식처럼) 렌더링 비용이 계속
    // 커지다가 빠르게 넘길 때 반응이 멈추는 문제가 있었다.
    private let visibleStackSize = 3

    var voteCardData: [VoteCard] = []
    // 왼쪽 스와이프(뒤로가기)로 돌아올 카드를 미리보기용으로 들여다본다 — history에서 실제로
    // 꺼내지는(consume) 건 moveBackCardToFront()뿐이고, 이건 그냥 조회만 한다.
    var previousCard: VoteCard? { buffers[currentType]?.history.last }
    var showsLoginRequired = false
    // 게시글 상세 투표 버튼과 동일하게, 내가 고른 쪽 옆에 보여줄 내 프로필 사진.
    var myProfileImageUrl: URL?

    private(set) var isLoggedIn: Bool

    init(
        voteCardRepository: VoteCardRepository = MockVoteCardRepository(),
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        isLoggedIn: Bool = true
    ) {
        self.voteCardRepository = voteCardRepository
        self.userInfoRepository = userInfoRepository
        self.isLoggedIn = isLoggedIn
    }

    // 게스트는 로그인 계정이 없어서 서버에 프로필 사진을 물어볼 수 없다 — 그 경우
    // myProfileImageUrl은 nil로 남고, 투표 버튼 쪽에서 기본 이미지로 대체해서 보여준다.
    @MainActor
    func loadMyProfileImage() async {
        guard isLoggedIn else { return }
        myProfileImageUrl = try? await userInfoRepository.fetchUserInfo().profileImageUrl
    }

    // GET /posts/random(커서 기반, type 하나만 받음)을 찬반/AB 각각 첫 페이지만 미리 받아
    // pending에 채워둔다. 실제로 화면에 띄우는 건 filterCards(by:)가 한다.
    @MainActor
    func loadCards() async {
        async let forAgainstPage = try? voteCardRepository.fetchCards(type: .forAgainst, cursor: nil)
        async let abPage = try? voteCardRepository.fetchCards(type: .ab, cursor: nil)
        let forAgainst = await forAgainstPage
        let ab = await abPage

        buffers[.forAgainst] = CardBuffer(pending: forAgainst?.items ?? [], cursor: forAgainst?.nextCursor, hasNext: forAgainst?.hasNext ?? false)
        buffers[.ab] = CardBuffer(pending: ab?.items ?? [], cursor: ab?.nextCursor, hasNext: ab?.hasNext ?? false)
    }

    // 홈 화면 상단 찬반/AB 탭 전환 시 호출된다. 지금 보고 있던 타입의 스택 상태를 스냅샷으로
    // 저장해두고, 전환할 타입의 스냅샷을 복원한다 — 처음 보는 타입이면 pending에서 채운다.
    @MainActor
    func filterCards(by type: VoteType) {
        buffers[currentType]?.displayed = voteCardData
        currentType = type

        if buffers[type]?.displayed.isEmpty ?? true {
            fillDisplayed(for: type)
        }
        voteCardData = buffers[type]?.displayed ?? []
        Task { await refillPendingIfNeeded(for: type) }
    }

    @MainActor
    func vote(cardID: Int, side: PostDetailVoteSide) async {
        guard let index = voteCardData.firstIndex(where: { $0.id == cardID }), !voteCardData[index].isVoted else { return }

        guard isLoggedIn else {
            showsLoginRequired = true
            return
        }

        let card = voteCardData[index]
        guard let optionId = side == .first ? card.firstOptionId : card.secondOptionId else { return }

        guard let result = try? await voteCardRepository.castVote(postId: cardID, optionId: optionId) else { return }
        voteCardData[index].firstPercentage = result.firstPercentage
        voteCardData[index].secondPercentage = result.secondPercentage
        voteCardData[index].votedSide = side
    }

    // 맨 앞 카드를 history로 옮기고, pending에 쌓아둔 카드가 있으면 하나 꺼내 맨 뒤에 채워서
    // visibleStackSize를 유지한다. pending이 부족해지면 다음 페이지를 미리 당겨온다.
    @MainActor
    func moveTopCardToBack() {
        guard !voteCardData.isEmpty else { return }
        let card = voteCardData.removeFirst()
        buffers[currentType]?.history.append(card)
        // recyclePool엔 "이 타입에서 지금까지 본 적 있는 카드 전체"를 중복 없이 쌓아둔다 —
        // 재활용 카드가 다시 넘겨질 때도 이 줄을 타지만, 이미 들어있으면 다시 안 넣는다.
        if buffers[currentType]?.recyclePool.contains(where: { $0.id == card.id }) == false {
            buffers[currentType]?.recyclePool.append(card)
        }
        if let next = buffers[currentType]?.pending.first {
            buffers[currentType]?.pending.removeFirst()
            voteCardData.append(next)
        } else if buffers[currentType]?.hasNext == false,
                  let recycled = buffers[currentType]?.recyclePool.first(where: { candidate in
                      !voteCardData.contains(where: { $0.id == candidate.id })
                  }) {
            // 서버가 더 줄 카드가 없다고 확인된 경우(hasNext=false)에만 쓰는 마지막 안전장치 —
            // recyclePool에서 "지금 voteCardData에 이미 떠 있지 않은" 카드만 고르므로, 어떤
            // 타이밍이든 같은 카드가 동시에 두 번 보이는 일이 구조적으로 불가능하다.
            voteCardData.append(recycled)
        }
        Task { await refillPendingIfNeeded(for: currentType) }
    }

    // 왼쪽 스와이프(뒤로가기) 전용 — history 맨 뒤(가장 최근에 넘긴) 카드를 다시 맨 앞으로
    // 가져온다. 그 결과 visibleStackSize를 넘으면 맨 뒤 카드를 pending 맨 앞으로 돌려보내서
    // 스택 크기를 유지한다(카드를 잃어버리지 않고 나중에 다시 나오게). 이때 voteCardData에서
    // 밀려난 카드를 반환한다 — 호출부(CardStackView)가 그 카드를 잠깐 더 그려서 화면에서
    // 순간이동하듯 사라지지 않고 자연스럽게 빠지게 할 수 있도록.
    @MainActor
    func moveBackCardToFront() -> VoteCard? {
        guard let card = buffers[currentType]?.history.popLast() else { return nil }
        voteCardData.insert(card, at: 0)

        guard voteCardData.count > visibleStackSize else { return nil }
        let overflow = voteCardData.removeLast()
        buffers[currentType]?.pending.insert(overflow, at: 0)
        return overflow
    }

    @MainActor
    private func fillDisplayed(for type: VoteType) {
        guard var buffer = buffers[type] else { return }
        while buffer.displayed.count < visibleStackSize, !buffer.pending.isEmpty {
            buffer.displayed.append(buffer.pending.removeFirst())
        }
        buffers[type] = buffer
    }

    @MainActor
    private func refillPendingIfNeeded(for type: VoteType) async {
        guard !isFetchingMore else { return }
        guard let buffer = buffers[type], buffer.pending.count < visibleStackSize, buffer.hasNext else { return }

        isFetchingMore = true
        defer { isFetchingMore = false }

        guard let page = try? await voteCardRepository.fetchCards(type: type, cursor: buffer.cursor) else {
            print("[CardStack] fetchCards 실패 — type=\(type)")
            return
        }
        guard var updated = buffers[type] else { return }

        // 지금 화면에 떠 있는 카드(voteCardData)까지 포함해서 중복을 걸러야, 같은 카드가
        // 잠시 뒤에 또 나오는 걸 막을 수 있다.
        let liveIds = type == currentType ? voteCardData.map(\.id) : []
        let existingIds = Set(updated.pending.map(\.id) + updated.displayed.map(\.id) + updated.history.map(\.id) + liveIds)
        let newCards = page.items.filter { !existingIds.contains($0.id) }

        updated.pending += newCards
        updated.cursor = page.nextCursor
        updated.hasNext = page.hasNext
        buffers[type] = updated

        // 빠르게 연속 스와이프하면 이 fetch가 끝나기 전에 voteCardData가 바닥날 수 있다.
        // pending → voteCardData로 옮기는 건 원래 moveTopCardToBack()에서만 일어나는데,
        // voteCardData가 이미 비어버리면 그 함수 맨 앞 guard에 막혀 다시는 채워질 기회가
        // 없었다 — fetch가 막 끝난 지금, 지금 보고 있는 탭이면 여기서 바로 채워준다.
        if type == currentType {
            while voteCardData.count < visibleStackSize, let next = buffers[type]?.pending.first {
                buffers[type]?.pending.removeFirst()
                voteCardData.append(next)
            }
        }
    }
}
