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

            switch postViewModel.selectedType {
                case .forAgainst:
                VStack(alignment: .leading, spacing: 8) {
                    (Text(PostViewStrings.category) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                        .pickpleTypography(.body01)
                        .padding(.horizontal, 24)

                    PickpleDropdownView()

                }

            case .compare:
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        (Text(PostViewStrings.category) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                            .pickpleTypography(.body01)
                            .padding(.horizontal, 24)

                        PickpleDropdownView()
                    }

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

struct PickpleDropdownView: View {
    @State private var isExpanded = false
    @State private var selectedValue = "카테고리를 선택하세요"

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
