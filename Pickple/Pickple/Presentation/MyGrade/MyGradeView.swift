//
//  MyGradeView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 아바타/포인트 카드/리스트 간 세로 여백은 임시값, Figma 확인 후 조정
//  - 레벨 구간 설명 문구는 스크린샷 기준 하드코딩 — 실제 등급 정책 확정 필요
//

import SwiftUI

private let gradeDescriptions: [Int: String] = [
    1: "가입 시 기본 부여 0P",
    2: "누적 200P + 투표 20회",
    3: "누적 1,000P + 투표 100회",
    4: "누적 3,500P + 투표 300회",
    5: "누적 10,000P + 투표 1,000회",
]

struct MyGradeView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: {}),
                center: .text("나의 등급"),
                trailing: .none
            )

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Image("PickpleGradeCharacter\(myPageViewModel.userInfo?.level ?? 1)")
                            .resizable()
                            .frame(width: 120, height: 120)

                        HStack(spacing: 4) {
                            if let voteCount = myPageViewModel.userInfo?.voteCount {
                                Text("투표")
                                    .pickpleTypography(.label)
                                    .foregroundStyle(Color.neutral40)
                                
                                Text("\(voteCount)")
                                    .pickpleTypography(.title02)
                                    .foregroundStyle(Color.black)
                                
                                Text("회")
                                    .pickpleTypography(.body02)
                                    .foregroundStyle(Color.neutral40)
                            }
                        }
                        
                        MyPagePointsView(myPageViewModel: myPageViewModel)
                    }
                    .padding(.bottom, 16)

                    Rectangle()
                        .frame(height: 4)
                        .foregroundStyle(Color.neutral5)
                    
                    VStack(spacing: 0) {
                        ForEach(1...5, id: \.self) { level in
                            MyGradeRow(level: level, description: gradeDescriptions[level] ?? "")
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .task {
            await myPageViewModel.loadUserInfo()
        }
    }
}

#Preview {
    MyGradeView(myPageViewModel: MyPageViewModel())
}
