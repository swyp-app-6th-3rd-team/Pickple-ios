//
//  CustomPhotoPickerView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
// 1차 점검 완료 - 9월 13일


import SwiftUI
import Photos
import UIKit

struct CustomPhotoPickerView: View {
    @Environment(\.dismiss) private var dismiss
    // selectionLimit이 1(기본값)이면 기존처럼 한 장 탭하는 즉시 선택·닫힘. 1보다 크면
    // 체크 표시로 여러 장을 골라뒀다가 "완료"를 눌러야 한 번에 전달된다.
    var selectionLimit: Int = 1
    let onSelect: ([UIImage]) -> Void

    @State private var viewModel = CustomPhotoPickerViewModel()
    @State private var showsCamera = false
    @State private var selectedAssets: [PHAsset] = []
    @State private var isConfirming = false

    private var isMultiSelect: Bool { selectionLimit > 1 }

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
                if isMultiSelect {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(CustomPhotoPickerStrings.done(selectedAssets.count)) {
                            confirmSelection()
                        }
                        .disabled(selectedAssets.isEmpty || isConfirming)
                    }
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
                    onSelect([image])
                    dismiss()
                }
            }
            .ignoresSafeArea()
        }
    }

    private func confirmSelection() {
        isConfirming = true
        Task {
            var images: [UIImage] = []
            for asset in selectedAssets {
                if let image = await viewModel.requestFullImage(for: asset) {
                    images.append(image)
                }
            }
            onSelect(images)
            dismiss()
        }
    }

    private func toggleSelection(of asset: PHAsset) {
        if let index = selectedAssets.firstIndex(where: { $0.localIdentifier == asset.localIdentifier }) {
            selectedAssets.remove(at: index)
        } else if selectedAssets.count < selectionLimit {
            selectedAssets.append(asset)
        }
    }

    private var cameraCell: some View {
        Button(action: {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            showsCamera = true
        }) {
            squareCell {
                ZStack {
                    Color.neutral10
                    Image("PickpleCamera")
                        .foregroundStyle(Color.neutral40)
                }
            }
        }
    }

    private func assetCell(_ asset: PHAsset) -> some View {
        let isSelected = selectedAssets.contains(where: { $0.localIdentifier == asset.localIdentifier })
        let isDisabled = isMultiSelect && !isSelected && selectedAssets.count >= selectionLimit

        return Button(action: {
            if isMultiSelect {
                toggleSelection(of: asset)
            } else {
                viewModel.requestFullImage(for: asset) { image in
                    guard let image else { return }
                    onSelect([image])
                    dismiss()
                }
            }
        }) {
            squareCell {
                if let thumbnail = viewModel.thumbnails[asset.localIdentifier] {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.neutral5
                }
            }
            .overlay(alignment: .topTrailing) {
                if isMultiSelect {
                    selectionBadge(isSelected: isSelected)
                        .padding(6)
                }
            }
            .opacity(isDisabled ? 0.4 : 1)
        }
        .disabled(isDisabled)
        .task {
            await viewModel.loadThumbnail(for: asset)
        }
    }

    private func selectionBadge(isSelected: Bool) -> some View {
        Circle()
            .fill(isSelected ? Color.navy60 : Color.white.opacity(0.7))
            .frame(width: 22, height: 22)
            .overlay {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.white)
                }
            }
            .overlay {
                Circle().stroke(Color.white, lineWidth: 1)
            }
    }

    // 사진마다 원본 비율이 달라서 .aspectRatio(1, contentMode: .fill)만으로는 칸 높이가
    // 사진마다 제각각으로 늘어졌다. GeometryReader로 실제 칸 너비를 잰 뒤 그 값 그대로
    // width/height에 강제로 프레임을 줘서 항상 정확한 정사각형이 되게 한다.
    private func squareCell<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        GeometryReader { geo in
            content()
                .frame(width: geo.size.width, height: geo.size.width)
                .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            CustomPhotoPickerView(onSelect: { _ in })
        }
}
