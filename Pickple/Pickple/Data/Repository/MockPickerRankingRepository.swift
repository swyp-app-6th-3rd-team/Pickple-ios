//
//  MockPickerRankingRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockPickerRankingRepository: PickerRankingRepository {
    private static let nicknamePool = [
        "픽플고인물", "라떼한잔", "구름위산책", "여름햇살", "냥냥펀치",
        "산책러", "밤샘러", "커피중독", "오늘의픽", "조용한선택",
        "미니멀리스트", "가성비헌터", "취향저격러", "고민끝판왕", "찬반요정",
        "댓글요정", "투표머신", "얼리어답터", "직진러", "신중러",
        "새벽감성", "주말picker", "출근길픽커", "야식파", "다이어터",
        "홈카페러버", "캠핑덕후", "러닝크루", "북마크왕", "리뷰장인"
    ]

    private static let all: [PickerRanking] = {
        var rankings: [PickerRanking] = []
        for (index, nickname) in nicknamePool.enumerated() {
            let level: Int = max(1, 5 - index / 6)
            let points: Int = max(50, 3000 - index * 95)
            rankings.append(
                PickerRanking(id: UUID(), rank: index + 1, nickname: nickname, level: level, profileImageName: "PickpleProfileSample", points: points)
            )
        }
        return rankings
    }()

    func fetchTopRankings() async throws -> [PickerRanking] {
        Array(Self.all.prefix(5))
    }

    // 실제 서버 cursor는 불투명 문자열이지만, Mock에서는 다음 조각 시작 오프셋을 문자열로 그대로 쓴다.
    func fetchRankings(cursor: String?) async throws -> RankingPage {
        let offset = cursor.flatMap(Int.init) ?? 0
        let page = Array(Self.all.dropFirst(offset).prefix(10))
        let nextOffset = offset + page.count
        let nextCursor = nextOffset < Self.all.count ? String(nextOffset) : nil
        return RankingPage(items: page, nextCursor: nextCursor)
    }
}
