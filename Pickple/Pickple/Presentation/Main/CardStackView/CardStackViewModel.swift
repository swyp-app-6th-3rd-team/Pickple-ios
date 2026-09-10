//
//  CardStackViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

@Observable
class CardStackViewModel {
    private var voteCardRepository: VoteCardRepository
    private let userInfoRepository: UserInfoRepository
    private var allCards: [VoteCard] = []

    private var forAgainstCursor: String?
    private var forAgainstHasNext = false
    private var abCursor: String?
    private var abHasNext = false
    private var isFetchingMore = false

    var voteCardData: [VoteCard] = []
    var showsLoginRequired = false
    // 게시글 상세 투표 버튼과 동일하게, 내가 고른 쪽 옆에 보여줄 내 프로필 사진.
    var myProfileImageUrl: URL?

    private(set) var isLoggedIn: Bool
    // 게스트 무료 투표 3회는 이 화면(홈 카드스택) 전용이 아니라 게시글 상세 투표와 공유된다
    // (기능명세서 2.2·6.3 모두 동일한 "3번까지 허용" 문구) — 그래서 앱 전체에서 하나만
    // 만들어 공유하는 GuestVoteTracker를 주입받는다.
    private let guestVoteTracker: GuestVoteTracker

    init(
        voteCardRepository: VoteCardRepository = MockVoteCardRepository(),
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        isLoggedIn: Bool = true,
        guestVoteTracker: GuestVoteTracker = GuestVoteTracker()
    ) {
        self.voteCardRepository = voteCardRepository
        self.userInfoRepository = userInfoRepository
        self.isLoggedIn = isLoggedIn
        self.guestVoteTracker = guestVoteTracker
    }

    // 게스트는 로그인 계정이 없어서 서버에 프로필 사진을 물어볼 수 없다 — 그 경우
    // myProfileImageUrl은 nil로 남고, 투표 버튼 쪽에서 기본 이미지로 대체해서 보여준다.
    func loadMyProfileImage() async {
        guard isLoggedIn else { return }
        myProfileImageUrl = try? await userInfoRepository.fetchUserInfo().profileImageUrl
    }

    // GET /posts/random은 type을 하나만 받아서, 찬반/AB를 각각 불러 합친다 —
    // 이후 탭 전환(filterCards)은 새 네트워크 호출 없이 이 합쳐둔 목록을 그냥 필터링만 한다.
    func loadCards() async {
        async let forAgainst = try? voteCardRepository.fetchCards(type: .forAgainst, cursor: nil)
        async let ab = try? voteCardRepository.fetchCards(type: .ab, cursor: nil)
        let forAgainstPage = await forAgainst
        let abPage = await ab
        allCards = (forAgainstPage?.items ?? []) + (abPage?.items ?? [])
        forAgainstCursor = forAgainstPage?.nextCursor
        forAgainstHasNext = forAgainstPage?.hasNext ?? false
        abCursor = abPage?.nextCursor
        abHasNext = abPage?.hasNext ?? false
    }

    // 홈 화면 상단 찬반/AB 탭 전환 시, 해당 유형의 카드만 다시 스와이프 스택으로 채운다.
    func filterCards(by type: VoteType) {
        voteCardData = allCards.filter { $0.type == type }
    }

    @MainActor
    func vote(cardID: Int, side: PostDetailVoteSide) async {
        guard let index = voteCardData.firstIndex(where: { $0.id == cardID }), !voteCardData[index].isVoted else { return }

        if !isLoggedIn {
            guard guestVoteTracker.registerVote() else {
                showsLoginRequired = true
                return
            }
            // 게스트는 토큰이 없어서 서버에 실제로 투표할 방법이 없다 — 로컬에서만 결과를 흉내낸다.
            let firstPercentage = side == .first ? Int.random(in: 55...80) : Int.random(in: 20...45)
            voteCardData[index].firstPercentage = firstPercentage
            voteCardData[index].secondPercentage = 100 - firstPercentage
            voteCardData[index].votedSide = side
            return
        }

        let card = voteCardData[index]
        guard let optionId = side == .first ? card.firstOptionId : card.secondOptionId else { return }

        guard let result = try? await voteCardRepository.castVote(postId: cardID, optionId: optionId) else { return }
        voteCardData[index].firstPercentage = result.firstPercentage
        voteCardData[index].secondPercentage = result.secondPercentage
        voteCardData[index].votedSide = side
    }

    // 카드를 배열에서 제거하지 않고 맨 뒤로 옮겨서, 다 넘기면 처음 카드부터 다시 무한으로 순환한다.
    // 서버에 아직 안 받아온 카드가 남아있으면(hasNext) 순환 전에 먼저 더 받아와서, 같은 카드를
    // 반복해서 보여주기 전에 실제 랜덤 카드를 최대한 먼저 소진한다.
    func moveTopCardToBack() {
        guard !voteCardData.isEmpty else { return }
        let card = voteCardData.removeFirst()
        voteCardData.append(card)
        Task { await loadMoreIfNeeded(for: card.type) }
    }

    private func loadMoreIfNeeded(for type: VoteType) async {
        guard !isFetchingMore else { return }
        let hasNext = type == .forAgainst ? forAgainstHasNext : abHasNext
        guard hasNext else { return }
        let cursor = type == .forAgainst ? forAgainstCursor : abCursor

        isFetchingMore = true
        defer { isFetchingMore = false }

        guard let page = try? await voteCardRepository.fetchCards(type: type, cursor: cursor) else { return }
        let existingIds = Set(allCards.map(\.id))
        let newCards = page.items.filter { !existingIds.contains($0.id) }
        allCards += newCards
        voteCardData += newCards.filter { $0.type == type }

        if type == .forAgainst {
            forAgainstCursor = page.nextCursor
            forAgainstHasNext = page.hasNext
        } else {
            abCursor = page.nextCursor
            abHasNext = page.hasNext
        }
    }
}
