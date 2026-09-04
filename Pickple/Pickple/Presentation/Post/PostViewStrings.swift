//
//  PostViewStrings.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

enum PostViewStrings {
    static let forAgainstPickTitle = "찬반"
    static let abPickTitle = "A/B"
    static let textPickTitle = "일반"

    static let requiredMark = "*"
    static let category = "카테고리"
    static let categoryPlaceholder = "카테고리를 선택해주세요"
    static let categoryOptions = ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]
    static let topic = "주제"
    static let topicText = "주제를 입력해주세요"

    // 글 유형 선택 바텀시트 행 타이틀
    static let forAgainstPickRowTitle = "찬반 PICK"
    static let abPickRowTitle = "A/B PICK"
    static let textPickRowTitle = "일반 게시글"

    // 글 작성 화면 GNB 타이틀
    static let forAgainstWriteTitle = "찬반 게시글 작성"
    static let abWriteTitle = "A/B 게시글 작성"
    static let textWriteTitle = "일반 게시글 작성"

    // 1단계 공통
    static let forAgainstStepOneTitle = "무슨 고민이신가요?"
    static let abStepOneTitle = "무슨 고민이신가요?"
    static let textStepOneTitle = "어떤 이야기를 나눠볼까요?"

    static let title = "제목"
    static let titlePlaceholder = "제목을 입력해주세요"
    static let description = "설명"
    static let descriptionPlaceholder = "상품에 대한 의견이나 고민을 적어주세요. 부적절한 내용은 즉시 삭제될 수 있습니다."

    // 상품 정보 단계
    static let productInfoTitle = "상품 정보를 입력해주세요"
    static let productATitle = "상품A의 정보를 입력해주세요"
    static let productBTitle = "상품B의 정보를 입력해주세요"
    static let photo = "사진"
    static let photoHintUpToThree = "최소 1장, 최대 3장 업로드"
    static let photoHintExactlyOne = "1장 필수"
    static let productName = "상품명"
    static let productNamePlaceholder = "상품명을 입력해주세요"
    static let price = "가격"
    static let priceUnit = "원"
    static let url = "URL"
    static let urlPlaceholder = "상품 URL을 붙여넣어주세요"

    // 버튼
    static let previous = "이전"
    static let next = "다음"
    static let submit = "게시"

    // 나가기 확인 모달
    static let leaveConfirmTitle = "작성 중인 내용이 있어요"
    static let leaveConfirmDescription = "페이지를 벗어나면 입력한 글이\n저장되지 않아요"
    static let leaveConfirmCancel = "취소"
    static let leaveConfirmConfirm = "나가기"

    // 토스트
    static let submitFailedToast = "게시글 등록에 실패했습니다. 다시 시도해 주세요."
    static let submitSucceededToast = "게시글이 성공적으로 등록되었습니다"
}
