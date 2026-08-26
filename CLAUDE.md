# 살래 말래?

상품을 올리면 다른 사용자들이 사라/사지마라를 투표해주는 앱.
iOS 클라이언트는 1인 개발. 서버·DB는 별도 백엔드 팀이 담당한다.

## 스택

- Swift 6, iOS 17.0+ / SwiftUI 전용 (UIKit은 불가피할 때만, 사유를 주석으로)
- `@Observable` 기반 MVVM. 뷰에 비즈니스 로직을 두지 않는다
- 비동기는 **async/await만**. Combine 신규 사용 금지
- 네비게이션은 `NavigationStack` + `NavigationPath`. `NavigationView` 금지
- Swift 6 strict concurrency 준수 (`Sendable`, actor isolation)
- 인증: KakaoSDK, AuthenticationServices

---

## 백엔드 연동 — 가장 중요

**서버 API 스펙은 백엔드 팀이 정한다. 확정되지 않은 엔드포인트·필드명·응답 구조를 지어내지 말 것.**

- 스펙 없는 기능은 `protocol` + Mock 구현까지만. 실제 통신은 스펙 확정 후에 붙인다
- 스펙이 필요하면 **추측해서 짜지 말고 먼저 물어볼 것**
- 확정된 스펙은 `Core/Network/API_SPEC.md`에 기록하고, 그 문서만을 근거로 구현한다
- DTO와 도메인 모델은 분리한다. 뷰가 DTO를 직접 참조하지 않는다
- 서버 필드명이 Swift 관례와 다르면 `CodingKeys`로 매핑한다. 프로퍼티명을 서버에 맞추지 않는다

```swift
protocol VoteRepository {
    func fetchFeed(cursor: String?) async throws -> [VoteItem]
    func submitVote(id: String, choice: VoteChoice) async throws
}
```

네트워크 계층은 반드시 protocol 기반 DI로 작성한다 — ViewModel 테스트에서 Mock을 주입할 수 있어야 한다.

---

## 도메인 규칙 (요구사항 정의서 기준)

- 투표 유형 2종: **찬반 픽**(사라 vs 마라), **비교 픽**(A vs B)
- 1계정당 1회 투표, 마감 전까지 취소 가능
- **투표 전에는 통계·참여 인원을 전면 블라인드.** 이 규칙을 깨는 UI를 만들지 말 것
- 게스트: 피드 탐색 무제한, 투표 3회까지. 4회차에 로그인 모달
- 로그인은 카카오·애플만. 이메일/비밀번호 방식은 구현하지 않는다
- 사진은 직접 업로드만. 외부 쇼핑몰 URL 크롤링은 범위 밖
- 입력 제한: 제품명 30자, 고민 한마디 100자, 댓글 300자
- 댓글 '유익하다' → 작성자에게 10P (본인 글 불가, 1인 1회)

---

## 코드 규칙

- **force unwrapping(`!`) 금지.** `guard let` / `if let` / `??` 사용
- `try!`, `as!` 금지
- UI를 갱신하는 ViewModel 메서드에는 `@MainActor` 명시
- 뷰가 50줄을 넘거나 두 곳 이상에서 쓰이면 별도 파일로 추출
- 하드코딩된 문자열·색상 금지 (상수, Asset Catalog 사용)
- 새 SPM 패키지 추가 전 반드시 확인받을 것. 버전은 고정

## 건드리지 말 것

- `*.pbxproj`, `*.xcodeproj/` 직접 수정 **금지**
  → 새 파일은 폴더 레퍼런스 아래 생성하면 Xcode가 자동 인식한다
- `Package.resolved` 수동 편집 금지
- `Info.plist`는 수정 전 확인받을 것
- `.env`, API 키, 토큰류 파일은 읽지도 쓰지도 말 것

---

## 완료 기준

**"작성했습니다"로 끝내지 말 것.** 아래를 통과해야 완료다.

1. 빌드 통과
2. 경고(warning)를 남기지 않는다. 남긴다면 사유를 설명한다
3. 로직 변경 시 관련 테스트 통과

```bash
xcodebuild -scheme <SCHEME> -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

xcodebuild test -scheme <SCHEME> \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Git

- 브랜치 `feat/`, `fix/` 프리픽스. `main` 직접 push 금지 (PR 필수)
- 커밋 메시지 한국어, `feat:` `fix:` `refactor:` `chore:` 프리픽스
- 한 커밋에 한 가지 변경

---

## 이 문서 관리 방법

같은 지적을 **두 번** 했다면 여기에 한 줄 추가한다.
안 지키게 된 규칙은 수정이 아니라 **삭제**한다. 200줄을 넘기지 않는다.

<!-- 추가 규칙
- 최소 수정(diff 최소화)보다 기존 코드 패턴과의 일관성을 우선한다. 같은 문제를 표현하는 방식이 이미 코드에 있다면 새로 다른 방식을 만들지 말고 그 패턴을 따를 것
-->
