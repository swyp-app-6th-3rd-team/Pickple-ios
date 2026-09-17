//
//  PickpleAsyncImage.swift
//  Pickple
//
//  Created by 박윤수 on 9/17/26.
//
//  AsyncImage는 같은 사진이 다시 보일 때도(스크롤 왔다갔다, 카드 재활용 등) 매번 새로
//  받고, 화면엔 작게 쓰는 사진도 서버 원본 해상도(확인된 사례 4000px대) 그대로 디코딩한다
//  — 그래서 느리고 메모리도 많이 먹는다. AsyncImage와 같은 2-클로저 형태를 유지하면서
//  (1) 한 번 받은 이미지를 메모리에 캐싱하고 (2) 필요한 크기로만 디코딩(다운샘플링)한다.

import SwiftUI
import UIKit
import ImageIO

private actor PickpleImageCache {
    static let shared = PickpleImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? { cache.object(forKey: url as NSURL) }
    func store(_ image: UIImage, for url: URL) { cache.setObject(image, forKey: url as NSURL) }
}

struct PickpleAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    // 실제로 화면에 그릴 크기(포인트 단위) — 이 크기 기준으로만 디코딩해서 원본 해상도를
    // 그대로 들고 있지 않게 한다. 실제 프레임보다 약간 크게 잡아도 무방(선명도 우선).
    let targetSize: CGSize
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            uiImage = nil
            await load()
        }
    }

    private func load() async {
        guard let url else { return }
        if let cached = await PickpleImageCache.shared.image(for: url) {
            uiImage = cached
            return
        }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
        guard let downsampled = Self.downsample(data: data, to: targetSize) else { return }
        await PickpleImageCache.shared.store(downsampled, for: url)
        uiImage = downsampled
    }

    // WWDC18 "Image and Graphics Best Practices" 권장 방식 — 원본을 전부 디코딩한 뒤
    // 축소하는 게 아니라, ImageIO가 파일에서 바로 목표 픽셀 크기로 썸네일을 뽑아낸다.
    private static func downsample(data: Data, to pointSize: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let maxPixelSize = max(pointSize.width, pointSize.height) * scale
        guard maxPixelSize > 0, let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
