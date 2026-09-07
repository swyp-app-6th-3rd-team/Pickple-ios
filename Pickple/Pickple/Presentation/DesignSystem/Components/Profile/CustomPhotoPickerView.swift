//
//  CustomPhotoPickerView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//  PhotosPicker는 애플이 완전히 캡슐화한 프로세스라 그리드에 커스텀 셀을 끼워 넣을 수 없어서,
//  PHAsset을 직접 가져와 같은 모양의 그리드를 그리고 첫 칸에 촬영 버튼을 둔다.
//  TODO: 여백/그리드 간격/색상은 임시값 — 디자인 확정 후 조정.

import SwiftUI
import Photos
import UIKit

struct CustomPhotoPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (UIImage) -> Void

    @State private var viewModel = CustomPhotoPickerViewModel()
    @State private var showsCamera = false

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isAuthorizationDenied {
                    Text(CustomPhotoPickerStrings.permissionDeniedMessage)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral40)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            cameraCell

                            ForEach(viewModel.assets, id: \.localIdentifier) { asset in
                                assetCell(asset)
                            }
                        }
                    }
                }
            }
            .navigationTitle(CustomPhotoPickerStrings.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(CustomPhotoPickerStrings.cancel) { dismiss() }
                }
            }
        }
        .task {
            await viewModel.requestAuthorizationAndLoadAssets()
        }
        .fullScreenCover(isPresented: $showsCamera) {
            CameraCaptureView { image in
                showsCamera = false
                if let image {
                    onSelect(image)
                    dismiss()
                }
            }
            .ignoresSafeArea()
        }
    }

    private var cameraCell: some View {
        Button(action: {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            showsCamera = true
        }) {
            ZStack {
                Color.neutral10
                Image("PickpleCamera")
                    .foregroundStyle(Color.neutral40)
            }
            .aspectRatio(1, contentMode: .fill)
        }
    }

    private func assetCell(_ asset: PHAsset) -> some View {
        Button(action: {
            viewModel.requestFullImage(for: asset) { image in
                guard let image else { return }
                onSelect(image)
                dismiss()
            }
        }) {
            Group {
                if let thumbnail = viewModel.thumbnails[asset.localIdentifier] {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.neutral5
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()
        }
        .task {
            await viewModel.loadThumbnail(for: asset)
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            CustomPhotoPickerView(onSelect: { _ in })
        }
}
