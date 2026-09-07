//
//  MyActivityVoteResultBar.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  TODO: 디자인 확정 필요 — 이기는 쪽에 마스코트 아이콘이 있어야 하는데 맞는 에셋이 없어서 생략함.
//
//  PostDetailVoteButtons(게시글 상세의 투표 버튼)와 시각 언어는 비슷하지만, 그건 인터랙티브
//  (투표 전/후 분기, onVote)이고 퍼센트도 화면 전체에 고정된 Mock값이라 그대로 재사용하지 않고
//  터치 없는 읽기 전용 버전으로 따로 둔다.

import SwiftUI

struct MyActivityVoteResultBar: View {
    let result: PostVoteResult

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                segment(
                    label: result.firstLabel,
                    percentage: result.firstPercentage,
                    isWinning: result.firstPercentage >= result.secondPercentage,
                    alignment: .leading
                )
                .frame(width: proxy.size.width * CGFloat(result.firstPercentage) / 100)

                segment(
                    label: result.secondLabel,
                    percentage: result.secondPercentage,
                    isWinning: result.secondPercentage > result.firstPercentage,
                    alignment: .trailing
                )
                .frame(width: proxy.size.width * CGFloat(result.secondPercentage) / 100)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 36)
    }

    private func segment(label: String, percentage: Int, isWinning: Bool, alignment: Alignment) -> some View {
        Text("\(label) \(percentage)%")
            .pickpleTypography(.label)
            .foregroundStyle(isWinning ? Color.white : Color.neutral70)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .padding(.horizontal, 12)
            .background(isWinning ? Color.neutral100 : Color.neutral10)
    }
}

#Preview("다양한 비율") {
    VStack(spacing: 12) {
        MyActivityVoteResultBar(result: PostVoteResult(firstLabel: "사자", secondLabel: "말자", firstPercentage: 70, secondPercentage: 30))
        MyActivityVoteResultBar(result: PostVoteResult(firstLabel: "A", secondLabel: "B", firstPercentage: 40, secondPercentage: 60))
        MyActivityVoteResultBar(result: PostVoteResult(firstLabel: "사자", secondLabel: "말자", firstPercentage: 30, secondPercentage: 70))
        MyActivityVoteResultBar(result: PostVoteResult(firstLabel: "A", secondLabel: "B", firstPercentage: 90, secondPercentage: 10))
    }
    .padding()
}
