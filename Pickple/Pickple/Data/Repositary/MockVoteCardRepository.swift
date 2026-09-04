//
//  MockVoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 목업 사진이 MockAgainstPicture 한 장뿐이라 전부 재사용함
import Foundation

struct MockVoteCardRepository: VoteCardRepository {
    func fetchCards() async -> [VoteCard] {
        forAgainstCards + abCards
    }

    private var forAgainstCards: [VoteCard] {
        [
            ("iPhone 17 Pro", "데일리로 쓸 폰 흰색 vs 오렌지색, 둘 다 예뻐서...", 1234),
            ("무선 이어폰", "이거 살까 말까 고민이에요", 12),
            ("나이키 에어포스 흰색", "때 탈까봐 걱정되는데 그래도 예뻐서 고민이에요", 892),
            ("무선 청소기", "흡입력 후기 갈려서 살까 말까 고민이에요", 341),
            ("캠핑 의자", "한 번 가고 안 쓸까봐 고민이에요", 57),
            ("전기 그릴", "자취방에서 쓰기엔 클까봐 고민이에요", 129),
            ("게이밍 마우스", "손이 작아서 그립감 걱정돼요", 76),
            ("가습기", "관리 귀찮아서 살까 말까 고민이에요", 203),
            ("러닝화", "쿠셔닝 좋다는데 가격이 부담돼요", 415),
            ("커피 머신", "매일 카페 갈 바엔 살까 고민이에요", 668),
            ("선크림", "백탁 걱정되는데 자외선 차단은 확실하대요", 990),
        ].map { name, concern, count in
            VoteCard(
                id: UUID(),
                type: .forAgainst,
                productName: name,
                concernText: concern,
                imageName: "MockAgainstPicture",
                secondImageName: nil,
                participantCount: count,
                firstPercentage: nil,
                secondPercentage: nil
            )
        }
    }

    private var abCards: [VoteCard] {
        [
            ("노트북 A vs B", "둘 중 뭐가 나을까요", 8),
            ("운동화 A vs B", "실착용했을 때 뭐가 더 편할지 모르겠어요", 234),
            ("무선 이어폰 A vs B", "통화 품질 위주로 보는데 뭐가 나을까요", 156),
            ("가방 A vs B", "활용도가 낮을까봐 고민돼요", 42),
            ("선크림 A vs B", "백탁 없고 산뜻한 걸로 고르려니 모르겠어요", 501),
            ("텀블러 A vs B", "보온력이 궁금해요", 19),
            ("키보드 A vs B", "타건감 차이가 클지 궁금해요", 88),
            ("모니터 A vs B", "눈 편한 쪽으로 고르고 싶어요", 320),
            ("백팩 A vs B", "수납 공간 차이가 궁금해요", 63),
            ("전자책 리더기 A vs B", "화면 크기 고민이에요", 137),
            ("무선 청소기 A vs B", "흡입력이랑 무게 둘 다 궁금해요", 275),
        ].map { name, concern, count in
            VoteCard(
                id: UUID(),
                type: .ab,
                productName: name,
                concernText: concern,
                imageName: "MockAgainstPicture",
                secondImageName: "MockAgainstPicture",
                participantCount: count,
                firstPercentage: nil,
                secondPercentage: nil
            )
        }
    }
}
