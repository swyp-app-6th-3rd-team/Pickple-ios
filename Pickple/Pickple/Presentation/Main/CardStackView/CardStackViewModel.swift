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

    // 카드를 배열에서 제거하지 않고 맨 뒤로 옮겨서, 다 넘기면 처음 카드부터 다시 무한으로 순환한다.
    // 서버에 아직 안 받아온 카드가 남아있으면(hasNext) 순환 전에 먼저 더 받아와서, 같은 카드를
    // 반복해서 보여주기 전에 실제 랜덤 카드를 최대한 먼저 소진한다.
    func moveTopCardToBack() {
        guard !voteCardData.isEmpty else { return }
        let card = voteCardData.removeFirst()
        voteCardData.append(card)
        Task { await loadMoreIfNeeded(for: card.type) }
    }

    // 왼쪽 스와이프(뒤로가기) 전용 — moveTopCardToBack()의 역순으로, 맨 뒤 카드(방금까지
    // 순환에서 가장 오래전에 넘겼던, 즉 바로 직전에 보고 있던 카드)를 다시 맨 앞으로 가져온다.
    func moveBackCardToFront() {
        guard !voteCardData.isEmpty else { return }
        let card = voteCardData.removeLast()
        voteCardData.insert(card, at: 0)
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
