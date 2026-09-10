//
//  MockPostWriteRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import Foundation

struct MockPostWriteRepository: PostWriteRepository {
    func createPost(
        type: VoteType,
        category: String,
        title: String?,
        description: String?,
        products: [PostWriteProductDraft]
    ) async throws -> Int {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return Int.random(in: 1...9999)
    }

    func updatePost(id: Int, category: String, title: String?, description: String) async throws {
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}
