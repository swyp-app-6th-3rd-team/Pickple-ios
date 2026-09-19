//
//  CommunitySearchView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  1차 점검 완료 - 9월 12일

import SwiftUI

struct CommunitySearchView: View {
    @State var communitySearchViewModel: CommunitySearchViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(CommunityRouter.self) private var communityRouter
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 9) {
                Button(action: { dismiss() }) {
                    Image("PickpleArrowLeft")
                        .foregroundStyle(Color.neutral40)
                }
                
                CommunitySearchField(
                    text: $communitySearchViewModel.searchText,
                    onSubmit: { communitySearchViewModel.recordSearch() }
                )
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            if communitySearchViewModel.submittedSearchText.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(CommunityStrings.recentSearchesTitle)
                            .pickpleTypography(.body01_500)
                            .foregroundStyle(Color.neutral100)
                        
                        Spacer()
                        
                        Button(action: { communitySearchViewModel.clearAllRecentSearches() }) {
                            Text("모두 지우기")
                                .pickpleTypography(.body02_600)
                                .foregroundStyle(Color.neutral40)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal,20)

                    
                    if !communitySearchViewModel.recentSearches.isEmpty {
                        // 최근 검색어가 쌓여서 화면 폭을 넘으면, 일반 HStack은 pill들을
                        // 압축시키고 lineLimit이 없는 Text가 그 안에서 줄바꿈돼 글자가
                        // 여러 줄로 꺾여 보였다 — 가로 스크롤 가능하게 바꾸고 한 줄로 고정한다.
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(communitySearchViewModel.recentSearches, id: \.self) { term in

                                    HStack(spacing: 6) {
                                        Button(action: { communitySearchViewModel.selectRecentSearch(term) }) {
                                            Text(term)
                                                .lineLimit(1)
                                                .pickpleTypography(.body02_600)
                                                .foregroundStyle(Color.neutral70)
                                        }
                                        Button(action: { communitySearchViewModel.removeRecentSearch(term) }) {
                                            Image("PickpleX")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color.neutral30)
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .padding(.trailing, 12)
                                    .padding(.vertical, 6)
                                }
                                .background(
                                    Capsule()
                                        .foregroundStyle(Color.white)
                                        .overlay {
                                            Capsule()
                                                .stroke(Color.navy10)
                                        })
                                
                            }
                            .padding(.horizontal,20)

                        }
                        .padding(.vertical, 6)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 6)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    // 결과가 0건이어도 "검색결과 0건" 헤더는 그대로 보여준다 — 결과 유무와
                    // 무관하게 항상 노출.
                    (Text(CommunityStrings.searchResultPrefix)
                        .foregroundStyle(Color.neutral80)
                     + Text("\(communitySearchViewModel.results.count)")
                        .foregroundStyle(Color.yellow70)
                     + Text(CommunityStrings.searchResultSuffix)
                        .foregroundStyle(Color.neutral80))
                    .pickpleTypography(.body01_500)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    if communitySearchViewModel.results.isEmpty {
                        VStack(spacing: 0) {
                            VStack(spacing: 30) {
                                Image("PickpleNoSearch")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4)
                                
                                VStack(spacing: 4) {
                                    Text("검색 결과가 없어요")
                                        .pickpleTypography(.title02_600)
                                        .foregroundStyle(Color.neutral70)
                                    
                                    Text("다른 검색어를 입력해 보세요")
                                        .pickpleTypography(.body02_600)
                                        .foregroundStyle(Color.neutral30)
                                }
                            }
                            .offset(y: 150)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 6) {
                                ForEach(communitySearchViewModel.results) { post in
                                    VStack(spacing: 0) {
                                        Button(action: {
                                            communityRouter.push(.postDetail(postId: post.id, type: post.type))
                                        }) {
                                            CommunitySearchResultCardView(post: post)
                                                .contentShape(Rectangle())
                                        }
                                        .buttonStyle(.plain)
                                        .task { prefetchUpcomingImages(after: post) }

                                        Divider()
                                            .foregroundStyle(Color.navy10)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .restoresSwipeBackGesture()
        .task {
            await communitySearchViewModel.loadPosts()
        }
        .onChange(of: communitySearchViewModel.searchText) { _, newValue in
            if newValue.isEmpty {
                communitySearchViewModel.clearSearch()
            }
        }
    }

    // 검색 결과는 페이지네이션 없이 한 번에 다 뜨는 목록이라, 다음 3장을 미리 받아둔다 —
    // CommunitySearchResultCardView(PostCardImage, 72x72)와 같은 target size.
    private func prefetchUpcomingImages(after post: PostSummary) {
        guard let index = communitySearchViewModel.results.firstIndex(where: { $0.id == post.id }) else { return }
        let urls = communitySearchViewModel.results[index...].dropFirst().prefix(3).compactMap { $0.thumbnailUrl }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: 72, height: 72))
    }
}

private struct CommunitySearchField: View {
    @Binding var text: String
    var onSubmit: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 12) {
            Image("PickpleSearch")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.neutral50)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(CommunityStrings.searchPlaceholder)
                        .pickpleTypography(.body01_500)
                        .foregroundStyle(Color.neutral40)
                }
                TextField("", text: $text)
                    .pickpleTypography(.body01_500)
                    .foregroundStyle(Color.neutral100)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)
            }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image("PickpleErase")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        .background(Capsule().fill(Color.neutral5))
    }
}

#Preview("최근 검색어") {
    let viewModel = CommunitySearchViewModel(userDefaults: UserDefaults(suiteName: "preview.communitySearch.recent")!)
    viewModel.searchText = "나이키"
    viewModel.recordSearch()
    viewModel.searchText = "청소기"
    viewModel.recordSearch()
    viewModel.searchText = ""
    viewModel.clearSearch()
    
    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
}

#Preview("검색 결과") {
    let viewModel = CommunitySearchViewModel(userDefaults: UserDefaults(suiteName: "preview.communitySearch.results")!)
    viewModel.searchText = "나이키"
    viewModel.recordSearch()
    
    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
    .task { await viewModel.loadPosts() }
}

#Preview("검색 결과 없음") {
    let viewModel = CommunitySearchViewModel(userDefaults: UserDefaults(suiteName: "preview.communitySearch.empty")!)
    viewModel.searchText = "존재하지않는검색어"
    viewModel.recordSearch()
    
    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
    .task { await viewModel.loadPosts() }
}
