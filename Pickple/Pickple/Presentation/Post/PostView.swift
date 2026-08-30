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
            // .compare 케이스처럼 한 단계 더 안쪽에 걸린 zIndex는 여기까지 전파되지 않는다.
            // 펼쳐졌을 때 이 지점까지 리스트가 넘칠 수 있으므로 여기서도 별도로 zIndex를 걸어준다.
            Group {
                switch postViewModel.selectedType {
                    case .forAgainst:
                    floatingCategoryBlock()

                case .compare:
                    VStack(spacing: 20) {
                        floatingCategoryBlock()

                        VStack(alignment: .leading, spacing: 8) {
                            (Text(PostViewStrings.topic) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                                .pickpleTypography(.body01)
                                .padding(.horizontal, 24)


                            PickpleTextField(
                                text: $postViewModel.topic,
                                type: .both,
                                placeholder: ProfileStrings.nicknameText,
                                trailingAccessory: .text("\(postViewModel.topic.count)/\(postViewModel.topicMaxLength)")
                            )
                            .padding(.horizontal, 20)
                        }

                    }
                case .text:
                    Text("C")
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

    @ViewBuilder
    private func categoryBlock(isExpanded: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(PostViewStrings.category) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)
                .padding(.horizontal, 24)

            PickpleDropdownView(isExpanded: isExpanded, selectedValue: $postViewModel.selectedCategory)
        }
    }

    // 접힌 상태 복사본으로 레이아웃 공간만 차지시키고, 실제 펼쳐질 수 있는 버전은 그 위에 overlay로 띄운다.
    // → 펼쳐져도 아래 형제 뷰(topic 필드 등)를 밀어내지 않으면서, zIndex로 그 위에 겹쳐 보이게 한다.
    private func floatingCategoryBlock() -> some View {
        categoryBlock(isExpanded: .constant(false))
            .hidden()
            .allowsHitTesting(false)
            .overlay(alignment: .top) {
                categoryBlock(isExpanded: $isCategoryExpanded)
            }
            .zIndex(1)
    }
}

struct PickpleDropdownView: View {
    @Binding var isExpanded: Bool
    @Binding var selectedValue: String

    let options = ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 드롭다운 버튼 영역
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedValue)
                        .foregroundStyle(Color.neutral40)
                        .padding(.leading, 21)
                    Spacer()
                    Image("PickpleArrowUp")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .padding(.trailing, 21)
                }
                .frame(maxWidth: .infinity, minHeight: 56)
            }

            // 펼쳐지는 리스트 영역
            if isExpanded {
                Divider()

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedValue = option
                            withAnimation(.spring()) {
                                isExpanded = false
                            }
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                        }
                        .foregroundColor(.neutral80)

                        if option != options.last {
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.navy10, lineWidth: 1)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PostView()
}
