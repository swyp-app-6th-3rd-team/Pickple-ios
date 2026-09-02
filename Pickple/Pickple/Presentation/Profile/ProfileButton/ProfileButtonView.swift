//
//  ProfileButtonView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct ProfileButtonView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Button(action: { }) {
            Text("확인")
        }
        .frame(maxWidth: .infinity) //반응형
        .buttonStyle(.pickple(profileViewModel.isNicknameValid() ? .enabled : .disabled, 56))
        .disabled(!profileViewModel.isNicknameValid())
    }
}

#Preview {
    ProfileButtonView(profileViewModel: ProfileViewModel())
}
