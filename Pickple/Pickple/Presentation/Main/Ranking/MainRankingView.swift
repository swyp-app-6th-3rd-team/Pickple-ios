//
//  MainRankingView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 실제 내 순위 행이 스크롤로 화면에 온전히 들어왔는지 추적하기 위한 프레임 값.
private struct MyRankRowFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    // ForEach의 다른 행들은 이 preference를 설정하지 않아 기본값(.zero)을 들고 reduce에 참여한다.
    // 그냥 덮어쓰면 내 순위 행 뒤에 처리되는 행들의 기본값이 실제 프레임을 지워버리므로,
    // 실제 값(.zero가 아닌 값)이 들어올 때만 덮어쓴다.
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let next = nextValue()
        if next != .zero {
            value = next
        }
    }
}

private extension View {
    func rankingFloatingCardStyle() -> some View {
        self
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    topTrailingRadius: 24
                )
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            }
    }
}

struct MainRankingView: View {
    @State private var mainRankingViewModel: MainRankingViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appRequestLogin) private var appRequestLogin

    @State private var scrollContainerHeight: CGFloat = 0
    @State private var myRankRowFrame: CGRect = .zero
    @State private var showsLoginRequired = false

    init(mainRankingViewModel: MainRankingViewModel = MainRankingViewModel()) {
        _mainRankingViewModel = State(initialValue: mainRankingViewModel)
    }

    // 고정 카드는 리스트 실제 행과 달리 세로 패딩(myRankCardVerticalPadding)만큼 안쪽으로
    // 내용이 들어가 있어서, 실제 행이 뷰포트 하단에 딱 닿는 시점(offset 0)이 아니라
    // 그 패딩만큼 못 미친 시점에 이미 카드 안 내용과 같은 자리를 차지한다.
    private let myRankCardVerticalPadding: CGFloat = 16

    // 내 순위 행이 고정 카드 안 내용과 같은 자리에 도달하는 순간, 그 즉시 카드를 치워서
    // 원래 거기 있었던 것처럼 보이게 한다(페이드 없이).
    private var isMyRankRowVisible: Bool {
        myRankRowFrame != .zero && myRankRowFrame.maxY <= scrollContainerHeight - myRankCardVerticalPadding
    }

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MainStrings.rankingTitle),
                trailing: .none
            )

            if mainRankingViewModel.rankings.isEmpty {
                Spacer()
                Text(MainStrings.rankingEmptyMessage)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral40)
                Spacer()
            } else {
                ZStack(alignment: .bottom) {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(mainRankingViewModel.rankings) { ranking in
                                PickerRankingRow(ranking: ranking)
                                    .task { await mainRankingViewModel.loadMoreIfNeeded(currentItem: ranking) }
                                    .background {
                                        if mainRankingViewModel.isLoggedIn && ranking.rank == mainRankingViewModel.myRanking.rank {
                                            GeometryReader { rowGeo in
                                                Color.clear
                                                    .preference(key: MyRankRowFramePreferenceKey.self, value: rowGeo.frame(in: .named("rankingScroll")))
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(20)
                    }
                    .coordinateSpace(name: "rankingScroll")
                    .background {
                        GeometryReader { containerGeo in
                            Color.clear
                                .onAppear { scrollContainerHeight = containerGeo.size.height }
                                .onChange(of: containerGeo.size.height) { _, newValue in scrollContainerHeight = newValue }
                        }
                    }
                    .onPreferenceChange(MyRankRowFramePreferenceKey.self) { myRankRowFrame = $0 }

                    if mainRankingViewModel.isLoggedIn {
                        if !isMyRankRowVisible {
                            // 리스트 안 실제 행은 세로 패딩이 전혀 없는 순수 높이로 측정되므로(LazyVStack의
                            // .padding(20)은 전체 스택 가장자리에만 붙지 개별 행엔 안 붙음), 여기서도
                            // 세로 패딩 없이 가로 패딩만 맞춰야 겹치는 순간 높이가 정확히 일치한다.
                            PickerRankingRow(ranking: mainRankingViewModel.myRanking)
                                .padding(.horizontal, 20)
                                .padding(.vertical, myRankCardVerticalPadding)
                                .rankingFloatingCardStyle()
                        }
                    } else {
                        // 일반 랭킹 행과 같은 레이아웃(순위/프로필/닉네임)을 쓰되, 게스트는 실제 순위가
                        // 없으니 그 자리는 자리표시자로 채우고 포인트 자리만 로그인 버튼으로 바꾼다.
                        HStack(spacing: 6) {
                            HStack(spacing: 6) {
                                Text("-")
                                    .pickpleTypography(.title02)
                                    .foregroundStyle(Color.neutral40)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(Color.neutral20)
                                
                                Text(MainStrings.rankingGuestNickname)
                                    .pickpleTypography(.body01)
                                    .foregroundStyle(Color.neutral100)
                            }

                            Spacer()

                            Button(action: { showsLoginRequired = true }) {
                                Text("로그인하고 포인트 얻기")
                                    .pickpleTypography(.body01)
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(Color.neutral100))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .rankingFloatingCardStyle()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await mainRankingViewModel.loadInitial()
        }
        .overlay {
            if showsLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MainStrings.loginRequiredTitle,
                        description: MainStrings.loginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsLoginRequired = false },
                        onConfirm: {
                            showsLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }
        }
    }
}

#Preview("로그인") {
    NavigationStack {
        MainRankingView(mainRankingViewModel: MainRankingViewModel(isLoggedIn: true))
    }
}

#Preview("게스트") {
    NavigationStack {
        MainRankingView(mainRankingViewModel: MainRankingViewModel(isLoggedIn: false))
    }
}
