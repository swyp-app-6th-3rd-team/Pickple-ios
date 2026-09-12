//
//  PostVoteResult.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 목록 카드에서 투표 결과 바를 그리기 위한 값. '나의 활동 > 투표' 탭에서만 채워지고
//  그 외 화면은 nil로 둔다. GET /users/me/activities/votes의 selectedOptionId/options로
//  RemoteUserPostRepository가 채운다(2026-09-13부터 실연동).

struct PostVoteResult: Equatable {
    let firstLabel: String
    let secondLabel: String
    let firstPercentage: Int
    let secondPercentage: Int
    // 이 탭은 "내가 투표한 글"만 보여주므로 항상 값이 있다(미투표 상태 없음).
    let votedSide: PostDetailVoteSide
}
