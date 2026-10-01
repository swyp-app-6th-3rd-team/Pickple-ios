//
//  PostDetailProductSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료
// 링크 폰트도 body01로 통일하면 안되려나

import SwiftUI

// A/B 게시글에서 상품A/상품B 정보를 전환해서 보여주는 탭. 찬반 게시글에선 쓰이지 않는다.
struct PostDetailProductTabPicker: View {
    let firstLabel: String
    let secondLabel: String
    @Binding var selectedTab: PostDetailVoteSide

    private var selectedIndex: Binding<Int> {
        Binding(
            get: { selectedTab == .first ? 0 : 1 },
            set: { selectedTab = $0 == 0 ? .first : .second }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            PickpleTabBar(tabs: [firstLabel, secondLabel], selectedIndex: selectedIndex, color: .black)

        }
    }
}

// 상품명/가격/구매처 정보 블록. 라벨 글자 수가 달라도(가격 2자) 값 열이 맞도록 Grid로 정렬한다.
struct PostDetailProductInfo: View {
    let product: PostDetailProduct

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 6) {
            GridRow {
                label(PostDetailStrings.productNameLabel)
                value(product.name)
            }

            if let price = product.price {
                GridRow {
                    label(PostDetailStrings.priceLabel)
                    value("\(price.formatted())원")
                }
            }

            if let purchaseURL = product.purchaseURL {
                GridRow {
                    label(PostDetailStrings.purchaseLinkLabel, typography: .body02_500)

                    if let purchaseLink = product.purchaseLink {
                        Link(destination: purchaseLink) {
                            Text(purchaseURL)
                                .pickpleTypography(.body02_400)
                                .foregroundStyle(Color.blue60)
                                .underline()
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        Text(purchaseURL)
                            .pickpleTypography(.body02_400)
                            .foregroundStyle(Color.neutral100)
                            .underline()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private func label(_ text: String, typography: PickpleTypography = .body02_500) -> some View {
        Text(text)
            .pickpleTypography(typography)
            .foregroundStyle(Color.neutral30)
    }

    private func value(_ text: String) -> some View {
        Text(text)
            .pickpleTypography(.body01_600)
            .foregroundStyle(Color.neutral100)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        PostDetailProductTabPicker(firstLabel: "상품A", secondLabel: "상품B", selectedTab: .constant(.first))
        PostDetailProductInfo(product: PostDetailProduct(id: 1, name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/...", imageUrls: [], displayOrder: 1))
    }
    .padding()
}
