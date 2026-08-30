//
//  PostView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

struct PostView: View {
    @State private var viewModel = PostViewModel()

    var body: some View {
        VStack {
            PickpleGNB(leading: .button(icon: Image("PickpleArrowLeft"), action: {}), center: .text("게시글 작성"), trailing: .none)

            postView2()


            Spacer()


        }
    }

    private var typeSelectionStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.selectTypeTitle)
                .pickpleTypography(.heading02)
                .padding(.top, 32)


        }
        .padding(.horizontal, 20)
    }
}

struct postView2: View {
    @StateObject private var postViewModel = PostViewModel()
    @State private var currentIndex: Int = 0
    @State private var isCategoryExpanded = false
    private let categoryOptions = ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]

    private var totalSteps: Int {
        switch postViewModel.selectedType {
        case .forAgainst, .compare:
            return 3
        case .text:
            return 2

        }
    }

    var body: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 32) {
                PickpleProgressBar(totalSteps: totalSteps, currentIndex: currentIndex)


                    Text(PostViewStrings.selectTypeTitle)
                        .pickpleTypography(.heading02)
            }
            .padding(.horizontal, 20)


            VStack(alignment: .leading) {
                (Text(PostViewStrings.postType) + Text(PostViewStrings.requiredMark)
                    .foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)

                    .padding(.horizontal, 24)

                HStack(spacing: 8) {
                    Button(action: {postViewModel.selectedType = .forAgainst}) {
                        Text(PostViewStrings.forAgainstPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.forAgainst)))

                    Button(action: {postViewModel.selectedType = .compare}) {
                        Text(PostViewStrings.abPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.compare)))

                    Button(action: {postViewModel.selectedType = .text}) {
                        Text(PostViewStrings.textPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.text)))

                }
                .padding(.horizontal, 20)
            }

            // Spacer/확인 버튼은 이 Group과 같은 VStack(spacing: 40)의 직계 형제라서,
            // 각 스텝 뷰 내부에 걸린 zIndex는 여기까지 전파되지 않는다.
            // 펼쳐졌을 때 이 지점까지 리스트가 넘칠 수 있으므로 여기서도 별도로 zIndex를 걸어준다.
            Group {
                switch postViewModel.selectedType {
                case .forAgainst:
                    ForAgainstStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
                case .compare:
                    CompareStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
                case .text:
                    TextStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
                }
            }
            .zIndex(isCategoryExpanded ? 1 : 0)


            Spacer()

            Button(action: { currentIndex += 1 }) {
                Text("확인")
            }
            /*
            .buttonStyle(.pickple(postViewModel.isTypeSelected ? .enabled : .disabled))
            .disabled(!postViewModel.isTypeSelected)
             */
        }
    }
}

#Preview {
    PostView()
}
