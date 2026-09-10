//
//  PostDetail.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct PostDetailProduct: Identifiable {
    let id: Int
    let name: String
    let price: Int?
    let purchaseURL: String?
    let imageUrl: URL?
    let displayOrder: Int

    // 구매처 문자열에 스킴이 없으면 https를 붙여서 실제로 열 수 있는 URL로 만든다.
    var purchaseLink: URL? {
        guard let purchaseURL else { return nil }
        if purchaseURL.hasPrefix("http://") || purchaseURL.hasPrefix("https://") {
            return URL(string: purchaseURL)
        }
        return URL(string: "https://\(purchaseURL)")
    }
}

struct PostDetailVoteOption: Identifiable {
    let optionId: Int
    let label: String?
    let productId: Int?
    let displayOrder: Int
    // 투표하지 않았으면 서버 응답에서 이 두 필드 자체가 빠진다(투표 전 블라인드 규칙).
    let voteCount: Int?
    let percentage: Int?

    var id: Int { optionId }
}

// 일반 게시글은 이 값 자체가 nil(R-04).
struct PostDetailVote {
    let voted: Bool
    let selectedOptionId: Int?
    let voterCount: Int
    let products: [PostDetailProduct]
    let options: [PostDetailVoteOption]
}

enum PostDetailVoteSide: Equatable {
    case first
    case second
}

struct PostDetail: Identifiable {
    let id: Int
    let type: VoteType
    let category: String
    let title: String
    let description: String
    let createdAt: Date
    let commentCount: Int
    let authorId: Int
    let authorNickname: String
    let authorProfileImageUrl: URL?
    let authorGradeLevel: Int
    let authorGradeName: String
    let authorRanking: Int?
    let isMine: Bool
    // votingApplied(...)가 이 필드만 바꿔서 복사본을 만들 수 있으려면 var여야 한다.
    var vote: PostDetailVote?

    var participantCount: Int { vote?.voterCount ?? 0 }

    // 캐러셀용 사진 목록 — 찬반은 상품 1장, A/B는 상품마다 1장씩(R-03). 상품당 여러 장은
    // 서버가 지원하지 않는다(첫 등록 사진만 옴).
    var images: [URL] {
        (vote?.products ?? []).compactMap(\.imageUrl)
    }

    // 찬반: firstProduct만 사용. A/B: firstProduct=상품A, secondProduct=상품B. 일반: 둘 다 nil.
    var firstProduct: PostDetailProduct? {
        vote?.products.first { $0.displayOrder == 1 } ?? vote?.products.first
    }

    var secondProduct: PostDetailProduct? {
        vote?.products.first { $0.displayOrder == 2 }
    }

    private func option(displayOrder: Int) -> PostDetailVoteOption? {
        vote?.options.first { $0.displayOrder == displayOrder } ?? {
            let sorted = vote?.options.sorted { $0.displayOrder < $1.displayOrder }
            return displayOrder == 1 ? sorted?.first : sorted?.dropFirst().first
        }()
    }

    var firstOptionId: Int? { option(displayOrder: 1)?.optionId }
    var secondOptionId: Int? { option(displayOrder: 2)?.optionId }

    // 투표하지 않았으면 percentage 필드 자체가 없어서 nil — 투표 전 블라인드 규칙을 그대로 반영한다.
    var firstPercentage: Int? { option(displayOrder: 1)?.percentage }
    var secondPercentage: Int? { option(displayOrder: 2)?.percentage }

    var votedSide: PostDetailVoteSide? {
        guard let selectedOptionId = vote?.selectedOptionId else { return nil }
        if selectedOptionId == firstOptionId { return .first }
        if selectedOptionId == secondOptionId { return .second }
        return nil
    }

    // 투표 직후, 서버가 새로 알려준 득표율만 반영한 사본을 만든다 — 나머지 필드(상품/작성자
    // 정보 등)는 그대로 두고, 다시 전체 상세를 재조회하지 않아도 결과 바로 보여줄 수 있게 한다.
    func votingApplied(selectedOptionId: Int, firstPercentage: Int, secondPercentage: Int) -> PostDetail {
        guard let vote else { return self }

        let updatedOptions = vote.options.map { option -> PostDetailVoteOption in
            let percentage: Int?
            switch option.optionId {
            case firstOptionId: percentage = firstPercentage
            case secondOptionId: percentage = secondPercentage
            default: percentage = option.percentage
            }
            return PostDetailVoteOption(
                optionId: option.optionId,
                label: option.label,
                productId: option.productId,
                displayOrder: option.displayOrder,
                voteCount: option.voteCount,
                percentage: percentage
            )
        }

        var updated = self
        updated.vote = PostDetailVote(
            voted: true,
            selectedOptionId: selectedOptionId,
            voterCount: vote.voted ? vote.voterCount : vote.voterCount + 1,
            products: vote.products,
            options: updatedOptions
        )
        return updated
    }
}
