//
//  MainHotPostSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct MainHotPostSection: View {
    let posts: [PostSummary]
    let onTapPost: (PostSummary) -> Void
    let onTapMore: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(MainStrings.hotPostSectionTitle)
                    .pickpleTypography(.title02)
                    .foregroundStyle(Color.black)

                Spacer()

                Button(action: onTapMore) {
                    HStack(spacing: 2) {
                        Text(MainStrings.more)
                        Image(systemName: "chevron.right")
                    }
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
                }
            }

            if posts.isEmpty {
                Text(MainStrings.hotPostEmptyMessage)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(posts) { post in
                            MainHotPostCardView(post: post)
                                .onTapGesture { onTapPost(post) }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainHotPostSection(posts: [], onTapPost: { _ in }, onTapMore: {})
        .padding()
}
