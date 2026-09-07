//
//  PostVoteResult.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 목록 카드에서 투표 결과 바를 그리기 위한 값. 서버에 아직 없는 데이터라
//  '나의 활동 > 투표' 탭 Mock에서만 채워 넣고, 그 외 화면은 nil로 둔다.
//  TODO: 실제 투표 결과 API 연동 필요 — 현재는 MockUserPostRepository가 하드코딩한 값.

struct PostVoteResult: Equatable {
    let firstLabel: String
    let secondLabel: String
    let firstPercentage: Int
    let secondPercentage: Int
}
