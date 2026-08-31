//
//  CardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

private struct CardView: View {
    let data: VoteCard

    var body: some View {
        VStack(spacing: 0) {
            Image(data.imageName)
                .resizable()
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16,
                    style: .continuous
                ))
                .frame(width: 333, height: 296)

            ZStack {
                UnevenRoundedRectangle(
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    style: .continuous
                )
                .foregroundStyle(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 0)

                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.productName)
                            .pickpleTypography(.title02)
                            .foregroundStyle(Color.neutral100)

                        Text(data.concernText)
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.neutral40)
                    }
                    .padding(.horizontal, 20)

                    HStack(spacing: 8) {
                        Button(action: {}) {
                            Text("사자")
                        }
                        .buttonStyle(.pickple(._default, 48))

                        Button(action: {}) {
                            Text("말자")
                        }
                        .buttonStyle(.pickple(._default, 48))
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(width: 333, height: 144)
        }
    }
}


