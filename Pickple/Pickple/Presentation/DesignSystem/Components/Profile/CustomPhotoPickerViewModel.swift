//
//  CustomPhotoPickerViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  CustomPhotoPickerView가 직접 들고 있던 PHPhotoLibrary 접근/썸네일 로딩 로직을 뷰 밖으로 뺐다.
//  (CLAUDE.md: 뷰에 비즈니스 로직을 두지 않는다)

import Photos
import UIKit

@Observable
class CustomPhotoPickerViewModel {
    private(set) var assets: [PHAsset] = []
    private(set) var thumbnails: [String: UIImage] = [:]
    private(set) var isAuthorizationDenied = false

    private let imageManager = PHCachingImageManager()

    @MainActor
    func requestAuthorizationAndLoadAssets() async {
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
    func loadThumbnail(for asset: PHAsset) async {
        guard thumbnails[asset.localIdentifier] == nil else { return }

        let options = PHImageRequestOptions()
        // .fastFormat은 미리 캐시된 빠른 썸네일이 없으면 nil을 반환한다 — 시뮬레이터에
        // 드래그로 추가한 사진처럼 그 캐시가 아직 없는 경우 썸네일이 영영 안 뜨는
        // 원인이었다. .highQualityFormat은 캐시가 없어도 직접 렌더링해서 반환한다.
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        let image = await withCheckedContinuation { continuation in
            var didResume = false
            imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 150, height: 150),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                // requestImage의 콜백은 문서상 여러 번 불릴 수 있어서, continuation을
                // 두 번 resume하면 런타임이 크래시한다 — 첫 호출만 반영한다.
                guard !didResume else { return }
                didResume = true
                continuation.resume(returning: image)
            }
        }

        if let image {
            thumbnails[asset.localIdentifier] = image
        }
    }

    func requestFullImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
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

    // 여러 장을 순서대로 원본 화질로 가져올 때 쓰는 async 버전.
    func requestFullImage(for asset: PHAsset) async -> UIImage? {
        await withCheckedContinuation { continuation in
            requestFullImage(for: asset) { image in
                continuation.resume(returning: image)
            }
        }
    }
}
