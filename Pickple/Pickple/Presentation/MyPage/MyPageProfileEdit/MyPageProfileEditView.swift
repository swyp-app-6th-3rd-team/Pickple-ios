//
//  MyPageProfileEditView.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyPageProfileEditView: View {
    @State var profileViewModel: ProfileSetupViewModel = ProfileSetupViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            PickpleGNB(leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                       center: .text("프로필 수정"),
                       trailing: .none,
                       bar: false)
            VStack(spacing: 12) {
                ProfileImageView(profileViewModel: profileViewModel)

                VStack(alignment: .leading, spacing: 8) {
                    Text("닉네임")
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 4)
                    
                    ProfileTextFieldView(profileViewModel: profileViewModel)
                }
                .padding(.horizontal, 20)

            }

            Spacer()

            ProfileButtonView(
                profileViewModel: profileViewModel,
                onCompleted: {
                    Task {
                        if await profileViewModel.updateProfile() {
                            dismiss()
                        }
                    }
                })
            .padding(.horizontal, 20)
        }
        .task {
            await profileViewModel.loadCurrentProfile()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    MyPageProfileEditView()
}
