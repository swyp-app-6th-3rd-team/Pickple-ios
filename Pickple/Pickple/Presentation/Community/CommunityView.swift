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
                    CommunityHeaderView(communityViewModel: communityViewModel)
                    CommunityPostListSection(communityViewModel: communityViewModel)
                }

                CommunityFloatingButtons(
                    onScrollToTop: {
                        withAnimation {
                            scrollProxy.scrollTo("communityTop", anchor: .top)
                        }
                    },
                    onWrite: { showsLoginRequired = true }
                )

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
