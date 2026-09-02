//
//  CommunityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/간격은 임시값

import SwiftUI

struct CommunityView: View {
    @StateObject var communityViewModel: CommunityViewModel
    @State private var showsLoginRequired = false

    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack {
                VStack(spacing: 0) {
                    PickpleGNB(
                        leading: .text("커뮤니티"),
                        center: .none,
                        trailing: .button(icon: Image("PickpleSearch"), action: {})
                    )

                    Divider()

                    CommunityCategoryChipRow(selectedCategory: $communityViewModel.selectedCategory)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

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
                    .padding(.vertical, 12)
                    .zIndex(1)

                    if communityViewModel.displayedPosts.isEmpty {
                        CommunityEmptyView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                Color.clear
                                    .frame(height: 0)
                                    .id("communityTop")

                                ForEach(communityViewModel.displayedPosts) { post in
                                    CommunityPostCardView(post: post)

                                    Divider()
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Button(action: {
                                withAnimation {
                                    scrollProxy.scrollTo("communityTop", anchor: .top)
                                }
                            }) {
                                Image("PickpleArrowUp")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.black)
                                    .padding(16)
                                    .background(Circle().foregroundStyle(Color.white))
                            }

                            Button(action: { showsLoginRequired = true }) {
                                Image("PickpleWriting")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.white)
                                    .padding(16)
                                    .background(Circle().foregroundStyle(Color.black))
                            }
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
}

#Preview {
    CommunityView(communityViewModel: CommunityViewModel())
}
