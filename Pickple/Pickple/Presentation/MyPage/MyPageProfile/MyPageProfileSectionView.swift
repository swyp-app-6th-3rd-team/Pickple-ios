//
//  MyPageProfileSectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageProfileSectionView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        MyPageProfileImageView(myPageViewModel: myPageViewModel)
            .padding(.top, 30)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyPageProfileSectionView(myPageViewModel: MyPageViewModel())
}
