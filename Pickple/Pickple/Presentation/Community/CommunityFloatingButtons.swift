//
//  CommunityFloatingButtons.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct CommunityFloatingButtons: View {
    let onScrollToTop: () -> Void
    let onWrite: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Button(action: onScrollToTop) {
                        Image("PickpleArrowUp")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.black)
                            .padding(16)
                            .background(Circle().foregroundStyle(Color.white))
                    }

                    Button(action: onWrite) {
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
    }
}

#Preview {
    CommunityFloatingButtons(onScrollToTop: {}, onWrite: {})
}
