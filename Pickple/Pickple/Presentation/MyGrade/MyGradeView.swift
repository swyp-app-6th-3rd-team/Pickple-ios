//
//  MyGradeView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 아바타/포인트 카드/리스트 간 세로 여백은 임시값, Figma 확인 후 조정
//

import SwiftUI

struct MyGradeView: View {
    let myPageViewModel: MyPageViewModel
    @State var gradeViewModel: MyGradeViewModel = MyGradeViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MyGradeStrings.title),
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
                                Text(MyGradeStrings.voteCountPrefix)
                                    .pickpleTypography(.label)
                                    .foregroundStyle(Color.neutral40)

                                Text("\(voteCount)")
                                    .pickpleTypography(.title02)
                                    .foregroundStyle(Color.black)

                                Text(MyGradeStrings.voteCountSuffix)
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
                        ForEach(gradeViewModel.grades) { grade in
                            MyGradeRow(grade: grade)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .task {
            await myPageViewModel.loadUserInfo()
        }
        .task {
            await gradeViewModel.loadGrades()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyGradeView(myPageViewModel: MyPageViewModel())
}
