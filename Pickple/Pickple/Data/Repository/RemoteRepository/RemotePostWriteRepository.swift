//
//  RemotePostWriteRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  상품마다 사진을 먼저 POST /images(attachType=PRODUCT)로 올려서 itemContainerId를 받고,
//  그걸 POST /posts의 products[].itemContainerId에 넣어 게시글을 만든다. 사진이 없는 상품
//  (일반 게시글은 상품 자체가 없음)은 이미지 업로드를 건너뛴다.

import Foundation
import UIKit

private struct ImageUploadResponseDTO: Decodable {
    let itemContainerId: Int
}

private struct PostCreateProductRequestDTO: Encodable {
    let itemContainerId: Int
    let name: String
    let price: Int?
    let linkUrl: String?
}

private struct PostCreateRequestDTO: Encodable {
    let type: String
    let category: String
    let title: String?
    let description: String?
    let products: [PostCreateProductRequestDTO]?
}

private struct PostCreateResponseDTO: Decodable {
    let postId: Int
}

private struct PostUpdateRequestDTO: Encodable {
    let category: String?
    let title: String?
    let description: String?
}

struct RemotePostWriteRepository: PostWriteRepository {
    let apiClient: APIClientProtocol

    func createPost(
        type: VoteType,
        category: String,
        title: String?,
        description: String?,
        products: [PostWriteProductDraft]
    ) async throws -> Int {
        var productRequests: [PostCreateProductRequestDTO] = []
        for product in products {
            let itemContainerId = try await uploadImages(product.photos)
            productRequests.append(
                PostCreateProductRequestDTO(
                    itemContainerId: itemContainerId,
                    name: product.name,
                    price: product.price,
                    linkUrl: product.linkUrl
                )
            )
        }

        let requestBody = PostCreateRequestDTO(
            type: type.serverTypeValue,
            category: Self.categoryCode(for: category),
            title: title,
            description: description,
            products: productRequests.isEmpty ? nil : productRequests
        )
        let body = try JSONEncoder().encode(requestBody)

        let endpoint = APIEndpoint(method: .post, path: "/posts", body: body, requiresAuth: true)
        let response: PostCreateResponseDTO = try await apiClient.request(endpoint)
        return response.postId
    }

    func updatePost(id: Int, category: String, title: String?, description: String) async throws {
        let requestBody = PostUpdateRequestDTO(
            category: Self.categoryCode(for: category),
            title: title,
            description: description
        )
        let body = try JSONEncoder().encode(requestBody)
        let endpoint = APIEndpoint(method: .patch, path: "/posts/\(id)", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    private func uploadImages(_ images: [UIImage]) async throws -> Int {
        let files: [MultipartFile] = images.enumerated().compactMap { index, image in
            guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
            return MultipartFile(fieldName: "images", filename: "photo\(index).jpg", mimeType: "image/jpeg", data: data)
        }

        let endpoint = APIEndpoint(
            method: .post,
            path: "/images",
            queryItems: [URLQueryItem(name: "attachType", value: "PRODUCT")],
            multipartFiles: files,
            requiresAuth: true
        )
        let response: ImageUploadResponseDTO = try await apiClient.request(endpoint)
        return response.itemContainerId
    }

    // 화면에 쓰는 한글 카테고리 라벨 → 서버 enum 코드. RemoteUserPostRepository.categoryLabel(for:)의 반대 방향.
    private static func categoryCode(for label: String) -> String {
        switch label {
        case "패션/잡화": return "FASHION"
        case "전자제품": return "ELECTRONICS"
        case "화장품/뷰티": return "BEAUTY"
        case "생활용품": return "LIVING"
        default: return "ETC"
        }
    }
}
