//
//  MyPageStatsView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyPageStatsView: View {
    let myPageViewModel: MyPageViewModel
    // MyActivityView 탭 인덱스(0=투표, 1=댓글, 2=작성글)를 그대로 넘겨서 해당 탭으로 진입하게 한다.
    var onTapStat: (Int) -> Void = { _ in }

    // 게스트는 실제 활동 정보를 조회할 계정이 없어서 명세대로 0개 고정 표시한다.
    private var voteCount: Int { myPageViewModel.isLoggedIn ? (myPageViewModel.userInfo?.voteCount ?? 0) : 0 }
    private var commentCount: Int { myPageViewModel.isLoggedIn ? (myPageViewModel.userInfo?.commentCount ?? 0) : 0 }
    private var postCount: Int { myPageViewModel.isLoggedIn ? (myPageViewModel.userInfo?.postCount ?? 0) : 0 }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 2) {
                Text(MyPageStrings.voteCount)
                    .pickpleTypography(.label_600)
                    .foregroundStyle(Color.neutral40)

                Text("\(voteCount)")
                    .pickpleTypography(.title02_600)
                    .foregroundStyle(Color.neutral100)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { onTapStat(0) }

            Divider()
                .frame(height: 30)
                .foregroundStyle(Color.navy10)

            VStack(spacing: 2) {
                Text(MyPageStrings.commentCount)
                    .pickpleTypography(.label_600)
                    .foregroundStyle(Color.neutral40)

                Text("\(commentCount)")
                    .pickpleTypography(.title02_600)
                    .foregroundStyle(Color.neutral100)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { onTapStat(1) }

            Divider()
                .frame(height: 30)
                .foregroundStyle(Color.navy10)

            VStack(spacing: 2) {
                Text(MyPageStrings.postCount)
                    .pickpleTypography(.label_600)
                    .foregroundStyle(Color.neutral40)

                Text("\(postCount)")
                    .pickpleTypography(.title02_600)
                    .foregroundStyle(Color.neutral100)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { onTapStat(2) }
        }
        .frame(width: 353) //Fiexd

    }
}

#Preview {
    MyPageStatsView(myPageViewModel: MyPageViewModel())
}
