//
//  PostTypeSelectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 게시글 작성 진입 화면: 찬반/A-B/일반 중 글 유형을 고른다.
struct PostTypeSelectionView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(PostViewStrings.typeSelectionTitle),
                trailing: .none
            )

            VStack(alignment: .leading, spacing: 32) {
                Text(PostViewStrings.selectTypeTitle)
                    .pickpleTypography(.heading02)
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)

            VStack(alignment: .leading, spacing: 20) {
                (Text(PostViewStrings.postType) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)
                    .padding(.horizontal, 24)

                HStack(spacing: 8) {
                    Button(action: { postViewModel.selectedType = .forAgainst }) {
                        Text(PostViewStrings.forAgainstPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.forAgainst)))

                    Button(action: { postViewModel.selectedType = .compare }) {
                        Text(PostViewStrings.abPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.compare)))

                    Button(action: { postViewModel.selectedType = .text }) {
                        Text(PostViewStrings.textPickTitle)
                    }
                    .buttonStyle(.pickpleSelection(isSelected: postViewModel.isSelected(.text)))
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)

            Spacer()

            NavigationLink {
                PostWriteFlowView(postViewModel: postViewModel)
            } label: {
                Text(PostViewStrings.next)
            }
            .buttonStyle(.pickple(.enabled, 52))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    NavigationStack {
        PostTypeSelectionView(postViewModel: PostViewModel())
    }
}
