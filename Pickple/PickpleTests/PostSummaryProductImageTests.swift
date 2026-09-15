//
//  PostSummaryProductImageTests.swift
//  PickpleTests
//

import XCTest
@testable import Pickple

final class PostSummaryProductImageTests: XCTestCase {

    private func makePost(products: [PostSummaryProduct]) -> PostSummary {
        PostSummary(
            id: 1,
            type: .ab,
            category: "패션/잡화",
            title: "제목",
            description: "",
            thumbnailUrl: nil,
            authorProfileImageUrl: nil,
            voteCount: 0,
            commentCount: 0,
            createdAt: Date(),
            products: products
        )
    }

    func test_productImageUrl_returnsMatchingDisplayOrdersImage() {
        let aURL = URL(string: "https://cdn.pickple.app/a.jpg")!
        let bURL = URL(string: "https://cdn.pickple.app/b.jpg")!
        let post = makePost(products: [
            PostSummaryProduct(displayOrder: 1, imageUrl: aURL),
            PostSummaryProduct(displayOrder: 2, imageUrl: bURL)
        ])

        XCTAssertEqual(post.productImageUrl(displayOrder: 1), aURL)
        XCTAssertEqual(post.productImageUrl(displayOrder: 2), bURL)
    }

    func test_productImageUrl_returnsNilWhenProductHasNoPhoto() {
        let post = makePost(products: [
            PostSummaryProduct(displayOrder: 1, imageUrl: nil),
            PostSummaryProduct(displayOrder: 2, imageUrl: URL(string: "https://cdn.pickple.app/b.jpg")!)
        ])

        XCTAssertNil(post.productImageUrl(displayOrder: 1))
    }

    func test_productImageUrl_returnsNilWhenDisplayOrderMissing() {
        let post = makePost(products: [])

        XCTAssertNil(post.productImageUrl(displayOrder: 1))
    }
}
