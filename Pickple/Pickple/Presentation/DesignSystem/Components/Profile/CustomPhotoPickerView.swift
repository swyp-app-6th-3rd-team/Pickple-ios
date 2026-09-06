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

    @State private var assets: [PHAsset] = []
    @State private var thumbnails: [String: UIImage] = [:]
    @State private var isAuthorizationDenied = false
    @State private var showsCamera = false

    private let imageManager = PHCachingImageManager()
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if isAuthorizationDenied {
                    Text(CustomPhotoPickerStrings.permissionDeniedMessage)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral40)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            cameraCell

                            ForEach(assets, id: \.localIdentifier) { asset in
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
            await requestAuthorizationAndLoadAssets()
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
            requestFullImage(for: asset) { image in
                guard let image else { return }
                onSelect(image)
                dismiss()
            }
        }) {
            Group {
                if let thumbnail = thumbnails[asset.localIdentifier] {
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
            await loadThumbnail(for: asset)
        }
    }

    @MainActor
    private func requestAuthorizationAndLoadAssets() async {
        let status = await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
        guard status == .authorized || status == .limited else {
            isAuthorizationDenied = true
            return
        }

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        var fetched: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in fetched.append(asset) }
        assets = fetched
    }

    @MainActor
    private func loadThumbnail(for asset: PHAsset) async {
        guard thumbnails[asset.localIdentifier] == nil else { return }

        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true

        let image = await withCheckedContinuation { continuation in
            imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 150, height: 150),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }

        if let image {
            thumbnails[asset.localIdentifier] = image
        }
    }

    private func requestFullImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            completion(image)
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            CustomPhotoPickerView(onSelect: { _ in })
        }
}
