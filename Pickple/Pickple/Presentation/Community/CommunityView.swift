//
//  CommunityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/간격은 임시값

import SwiftUI

struct CommunityView: View {
    @StateObject var communityViewModel = CommunityViewModel()
    @State private var showsLoginRequired = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .text("커뮤니티"),
                    center: .none,
                    trailing: .button(icon: Image("PickpleSearch"), action: {})
                )

                CommunityCategoryChipRow(selectedCategory: $communityViewModel.selectedCategory)
                    .padding(.top, 8)

                HStack {
                    PickpleSortButton(
                        isExpanded: .constant(false),
                        selectedValue: $communityViewModel.sortOption,
                        options: CommunityViewModel.sortOptions
                    )
                    .floatingOverSiblings {
                        PickpleSortButton(
                            isExpanded: $communityViewModel.isSortExpanded,
                            selectedValue: $communityViewModel.sortOption,
                            options: CommunityViewModel.sortOptions
                        )
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .zIndex(1)

                if communityViewModel.displayedPosts.isEmpty {
                    CommunityEmptyView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(communityViewModel.displayedPosts) { post in
                                CommunityPostCardView(post: post)
                            }
                        }
                        .padding(20)
                    }
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showsLoginRequired = true }) {
                        Image("PickplePlus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.white)
                            .padding(20)
                            .background(Circle().foregroundStyle(Color.black))
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }

            if showsLoginRequired {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showsLoginRequired = false }

                CommunityLoginRequiredModal(
                    onCancel: { showsLoginRequired = false },
                    onConfirm: {
                        showsLoginRequired = false
                        //TODO: 로그인 플로우 연결 필요
                    }
                )
            }
        }
        .task {
            await communityViewModel.loadPosts()
        }
    }
}

#Preview {
    CommunityView()
}
