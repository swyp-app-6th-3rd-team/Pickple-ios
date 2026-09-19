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
    func store(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
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
        let downloadStart = Date()
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
        let downloadMs = Date().timeIntervalSince(downloadStart) * 1000
        print("[ImageDownload] \(url.lastPathComponent) target=\(Int(targetSize.width))x\(Int(targetSize.height)) \(data.count)bytes \(String(format: "%.0f", downloadMs))ms")
        // downsample은 ImageIO로 실제 디코딩까지 하는 CPU 작업이라, 그냥 이 뷰의(MainActor)
        // .task 안에서 부르면 메인 스레드가 그동안 막혀 스크롤/애니메이션이 끊긴다 —
        // detached Task로 빼서 백그라운드에서 계산하고 결과만 받아온다. UIScreen.main은
        // 메인 스레드에서 미리 읽어 값만 넘긴다(nonisolated 함수 안에서 직접 참조하지 않는다).
        let targetSize = targetSize
        let scale = UIScreen.main.scale
        guard let downsampled = await Task.detached(priority: .userInitiated, operation: {
            pickpleDownsample(data: data, to: targetSize, scale: scale)
        }).value else { return }
        await PickpleImageCache.shared.store(downsampled, for: url)
        uiImage = downsampled
    }
}

// WWDC18 "Image and Graphics Best Practices" 권장 방식 — 원본을 전부 디코딩한 뒤
// 축소하는 게 아니라, ImageIO가 파일에서 바로 목표 픽셀 크기로 썸네일을 뽑아낸다.
// PickpleAsyncImage(제네릭 타입)와 아래 PickpleImagePrefetcher(비제네릭)가 같이 쓰기
// 위해 타입 안에 두지 않고 파일 스코프 함수로 뺐다.
private nonisolated func pickpleDownsample(data: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
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

// 리스트를 스크롤하기 전에 다음에 보일 이미지를 미리 받아 PickpleImageCache를 데워둔다 —
// 실제로 그릴 필요는 없으니 화면에 안 보이는 상태로 다운로드+다운샘플만 해서 캐시에
// 넣어두면, 해당 셀이 실제로 나타날 때 캐시 히트로 바로 뜬다. 캐시에 이미 있으면 스킵.
// 스크롤이 빨라 놓친 프리패치는 그냥 낭비될 뿐 버그는 아니라 취소 처리는 하지 않는다
// (ponytail: 낭비 감수, 체감상 문제 되면 Task 핸들을 들고 있다가 취소하는 걸로 보강).
enum PickpleImagePrefetcher {
    static func prefetch(urls: [URL], targetSize: CGSize) {
        let scale = UIScreen.main.scale
        for url in urls {
            Task.detached(priority: .utility) {
                if await PickpleImageCache.shared.image(for: url) != nil { return }
                guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
                guard let downsampled = pickpleDownsample(data: data, to: targetSize, scale: scale) else { return }
                await PickpleImageCache.shared.store(downsampled, for: url)
            }
        }
    }
}
