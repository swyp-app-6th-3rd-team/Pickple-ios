//
//  PhotoUploadTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//

import SwiftUI

struct PhotoUploadTitleView: View {
    let hintText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            (Text(PostViewStrings.photo) + Text(" ") + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)
            
            Text(hintText)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)
        }
    }
}

#Preview {
    PhotoUploadTitleView(hintText: "최소 1장, 최대 3장 업로드")
}
