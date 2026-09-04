//
//  PostDetailProductSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백은 임시값

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
            PickpleTabBar(tabs: [firstLabel, secondLabel], selectedIndex: selectedIndex)

        }
    }
}

// 상품명/가격/구매처 정보 블록.
struct PostDetailProductInfo: View {
    let product: PostDetailProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            PostDetailProductInfoRow(label: PostDetailStrings.productNameLabel, value: product.name)
            PostDetailProductInfoRow(label: PostDetailStrings.priceLabel, value: "\(product.price.formatted())원")

            HStack(spacing: 8) {
                Text(PostDetailStrings.purchaseLinkLabel)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral30)
                    .frame(width: 36, alignment: .leading)

                if let purchaseLink = product.purchaseLink {
                    Link(destination: purchaseLink) {
                        Text(product.purchaseURL)
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.blue60)
                            .underline()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    Text(product.purchaseURL)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral100)
                        .underline()
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct PostDetailProductInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral30)
                .frame(width: 36, alignment: .leading)

            Text(value)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral100)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        PostDetailProductTabPicker(firstLabel: "상품A", secondLabel: "상품B", selectedTab: .constant(.first))
        PostDetailProductInfo(product: PostDetailProduct(name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/..."))
    }
    .padding()
}
