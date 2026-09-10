//
//  CommunitySearchView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/빈 상태 문구는 임시값

import SwiftUI

struct CommunitySearchView: View {
    @State var communitySearchViewModel: CommunitySearchViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(CommunityRouter.self) private var communityRouter

    var body: some View {
        VStack(spacing: 8) {
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
                // 타이틀/"모두 지우기"는 recentSearches 유무와 상관없이 항상 보여준다.
                // (이전엔 recentSearches.isEmpty 분기 안에 같이 있어서, 모두 지우기를 누르면
                // 그 즉시 recentSearches가 비면서 타이틀까지 같이 사라지는 문제가 있었다.)
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(CommunityStrings.recentSearchesTitle)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral100)

                        Spacer()

                        Button(action: { communitySearchViewModel.clearAllRecentSearches() }) {
                            Text("모두 지우기")
                                .pickpleTypography(.body02)
                                .foregroundStyle(Color.neutral30)
                        }
                    }

                    if !communitySearchViewModel.recentSearches.isEmpty {
                        HStack {
                            ForEach(communitySearchViewModel.recentSearches, id: \.self) { term in

                                HStack(spacing: 6) {
                                    Button(action: { communitySearchViewModel.selectRecentSearch(term) }) {
                                        Text(term)
                                            .pickpleTypography(.body02)
                                            .foregroundStyle(Color.neutral60)
                                    }
                                    Button(action: { communitySearchViewModel.removeRecentSearch(term) }) {
                                        Image("PickpleX")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(Color.neutral30)
                                    }
                                }
                                .padding(.horizontal, 16)
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
                    }

                    Spacer()
                }
                .padding(20)
            } else if communitySearchViewModel.results.isEmpty {
                VStack {
                    Spacer()
                    VStack(spacing: 30) {
                        Image("PickpleNoSearch")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.black.opacity(0.3), radius: 4)
                        
                        VStack(spacing: 4) {
                            Text("검색 결과가 없어요")
                                .pickpleTypography(.title02)
                                .foregroundStyle(Color.neutral70)
                            
                            Text("다른 검색어를 입력해 보세요")
                                .pickpleTypography(.body02)
                                .foregroundStyle(Color.neutral30)
                        }
                    }
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        (Text(CommunityStrings.searchResultPrefix)
                            .foregroundStyle(Color.neutral100)
                         + Text("\(communitySearchViewModel.results.count)")
                            .foregroundStyle(Color.yellow60)
                         + Text(CommunityStrings.searchResultSuffix)
                            .foregroundStyle(Color.neutral100))
                            .pickpleTypography(.body01)

                        ForEach(communitySearchViewModel.results) { post in
                            CommunitySearchResultCardView(post: post)
                                .onTapGesture {
                                    communityRouter.push(.postDetail(postId: post.id, type: post.type))
                                }

                            Divider()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await communitySearchViewModel.loadPosts()
        }
        .onChange(of: communitySearchViewModel.searchText) { _, newValue in
            if newValue.isEmpty {
                communitySearchViewModel.clearSearch()
            }
        }
    }
}

// PickpleTextField는 코너 반경 8짜리 사각형 테두리가 내부에 고정돼있어서 캡슐 모양으로
// 바꿀 방법이 없다. 다른 화면에서 쓰는 사각형 스타일에 영향을 주지 않으려고, 검색창 전용으로
// 아이콘+텍스트필드만 가진 가벼운 커스텀 뷰를 따로 둔다.
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
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral40)
                }
                TextField("", text: $text)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)
            }

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.neutral50)
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

    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
}

#Preview("검색 결과") {
    let viewModel = CommunitySearchViewModel(userDefaults: UserDefaults(suiteName: "preview.communitySearch.results")!)
    viewModel.searchText = "나이키"

    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
    .task { await viewModel.loadPosts() }
}

#Preview("검색 결과 없음") {
    let viewModel = CommunitySearchViewModel(userDefaults: UserDefaults(suiteName: "preview.communitySearch.empty")!)
    viewModel.searchText = "존재하지않는검색어"

    return NavigationStack {
        CommunitySearchView(communitySearchViewModel: viewModel)
    }
    .environment(CommunityRouter())
    .task { await viewModel.loadPosts() }
}
