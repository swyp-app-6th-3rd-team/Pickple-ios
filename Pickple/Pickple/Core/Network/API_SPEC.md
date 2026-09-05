# API_SPEC

백엔드 팀이 정한 확정 API 스펙. 이 문서만을 근거로 네트워크 계층/DTO를 구현한다. 스펙에 없는 엔드포인트·필드는 지어내지 말고 먼저 물어볼 것.

- OAS(Scalar, 인터랙티브 문서): https://dev-api.pickple.app/scalar
- 원본(LLM용 마크다운): https://dev-api.pickple.app/llms.md
- 버전: v1
- 마지막 확인: 2026-09-06

## 공통 규약

모든 응답은 다음 봉투로 감싸인다. 아래 각 엔드포인트의 응답 설명은 `returnObject` 안쪽 기준이다.

```json
{"code": "OK", "message": "정상 처리되었습니다.", "returnObject": <T>}
```

인증이 필요한 요청에는 `Authorization: Bearer {accessToken}` 헤더를 보낸다.

---

## User — 닉네임 · 프로필

### POST /users/profile — 프로필 등록
회원가입 직후 닉네임과 프로필 이미지를 등록한다. 이미지를 주지 않으면 랜덤 기본 프로필이 채워진다.

요청 본문:
- `nickname` 문자열 필수 — 5자 이내의 한글·영문·숫자. 유일성은 등록 시점에 판정되므로 409로 실패할 수 있다
- `profileImageUrl` 문자열 선택 — 주지 않으면 쓰던 이미지를 유지한다

응답 200 — OK:
- `userId` 정수(int64) 선택 — 사용자 식별자
- `nickname` 문자열 선택 — 서비스 닉네임. 프로필 등록 전이면 null
- `profileImageUrl` 문자열 선택 — 프로필 이미지. 등록 때 주지 않았으면 서비스가 고른 기본 이미지다

### PATCH /users/profile — 프로필 수정
닉네임과 프로필 이미지를 바꾼다. 이미지를 주지 않으면 쓰던 이미지를 유지한다. 요청/응답은 POST와 동일.

### GET /users/nickname/availability — 닉네임 사용 가능 여부
입력 중 실시간으로 부른다. 형식 위반은 400. 여기서 사용 가능이 나와도 등록까지의 사이에 선점될 수 있어, 등록은 409로 실패할 수 있다.

파라미터:
- `value` (query) 문자열 필수 — 확인할 닉네임

응답 200 — OK:
- `available` 불리언 선택 — 지금 이 닉네임을 쓸 수 있는지. 등록까지의 사이에 선점될 수 있다
- `message` 문자열 선택 — 화면에 그대로 보여줄 안내

### GET /users/me — 내 프로필 조회
인증 필요(401 가능).

응답 200 — OK: `userId`, `nickname`, `profileImageUrl` (위와 동일 의미)

---

## Vote — 투표 참여 · 결과

### POST /posts/{postId}/votes — 투표 참여
선택지에 투표한다. 이미 투표했으면 선택만 바뀌고 투표 인원은 늘지 않는다(R-22). 응답은 갱신된 선택지별 득표 수와 득표율이다.

파라미터:
- `postId` (path) 정수(int64) 필수

요청 본문:
- `optionId` 정수(int64) 필수 — 고른 선택지 id. 이 게시글의 선택지여야 한다(R-10)

응답 200 — OK:
- `postId` 정수(int64) 선택
- `selectedOptionId` 정수(int64) 선택 — 이번 요청으로 확정된 내 선택
- `voterCount` 정수(int64) 선택 — 투표한 사람 수. 한 사람이 선택을 바꿔도 늘지 않는다(R-09·R-22)
- `options` 배열 선택 — 선택지별 득표 수와 득표율. 그대로 결과 게이지가 된다
  - `optionId` 정수(int64) 선택
  - `label` 문자열 선택 — 찬반 선택지의 라벨. A/B는 null
  - `displayOrder` 정수(int32) 선택 — 표시 순서. 1 또는 2
  - `voteCount` 정수(int64) 선택
  - `percentage` 정수(int32) 선택 — 정수 퍼센트. 반올림 때문에 두 값의 합이 100이 아닐 수 있다. 아무도 투표하지 않았으면 0

---

## Comment — 댓글 · 원픽

### GET /posts/{postId}/comments — 댓글 목록 조회
게스트도 부를 수 있다. 토큰을 함께 보내면 각 항목의 `mine`이 채워지고, 게스트면 항상 false다.

파라미터:
- `postId` (path) 정수(int64) 필수

응답 200 — OK:
- `commentCount` 정수(int64) 선택 — 활성 댓글 건수. 삭제된 댓글은 세지 않는다
- `comments` 배열 선택 — (created_at, id) 오름차순. 페이징 없이 전체를 준다
  - `id` 정수(int64) 선택
  - `authorId` 정수(int64) 선택
  - `profileImageUrl` 문자열 선택
  - `nickname` 문자열 선택 — 아직 설정하지 않은 사용자는 소셜 이름을 대신 쓴다
  - `createdAt` 문자열(date-time) 선택
  - `createdAgo` 문자열 선택 — 화면용 상대 시각
  - `content` 문자열 선택
  - `onePickCount` 정수(int64) 선택 — 이 댓글이 받은 원픽 수
  - `mine` 불리언 선택 — 현재 요청자가 쓴 댓글인지. 게스트 요청은 항상 false

### POST /posts/{postId}/comments — 댓글 작성
파라미터: `postId` (path) 정수(int64) 필수
요청 본문: `content` 문자열 필수 — 300자 이내
응답 200 — OK: `id`, `content`

### POST /comments/{commentId}/pick — 댓글 원픽
한 사람은 한 게시글에서 댓글 하나만 원픽한다(R-05). 취소·변경은 없다(R-06). 이미 원픽했으면 409, 자기 댓글이면 400.

파라미터: `commentId` (path) 정수(int64) 필수
응답 200 — OK:
- `id` 정수(int64) 선택 — 원픽 식별자. 포인트 지급의 멱등키다(R-13)
- `commentId` 정수(int64) 선택

### PATCH /comments/{id} — 댓글 수정
파라미터: `id` (path) 정수(int64) 필수
요청 본문: `content` 문자열 필수 — 300자 이내
응답 200 — OK: `id`, `content`

### DELETE /comments/{id} — 댓글 삭제
파라미터: `id` (path) 정수(int64) 필수
응답 200 — OK: any

---

## Image — 이미지 업로드

### POST /images — 이미지 업로드
multipart `images`를 S3에 저장하고 부착에 쓸 `itemContainerId`를 반환한다.

파라미터:
- `attachType` (query) 문자열 필수 — 이미지 용도

요청 본문:
- `images` 배열 필수 — 문자열(binary) 배열

응답 201 — Created:
- `itemContainerId` 정수(int64) 선택 — 게시글·댓글에 부착할 때 넘기는 컨테이너 식별자
- `images` 배열 선택 — 이번 요청으로 올라간 파일들
  - `resourceId` 정수(int64) 선택
  - `originalFileName` 문자열 선택
  - `size` 정수(int64) 선택 — 파일당 5MB를 넘으면 413
  - `accessUrl` 문자열 선택 — CloudFront 접근 URL. 만료되지 않는다

---

## Auth — 소셜 로그인 · JWT

### POST /auth/refresh — 토큰 재발급(웹)
리프레시 토큰은 HttpOnly 쿠키에서 읽는다. 성공 시 쿠키도 새 값으로 교체된다.
파라미터: `refresh_token` (cookie) 문자열 선택
응답 200 — OK: `accessToken` 문자열 선택 — 리프레시 토큰은 본문에 없고 HttpOnly 쿠키로만 간다

### POST /auth/mobile/refresh — 모바일 토큰 재발급
Keychain에 보관한 refresh token을 받아 회전된 access/refresh token을 JSON으로 반환한다.
요청 본문: `refreshToken` 문자열 필수 — Keychain에 보관한 리프레시 토큰
응답 200 — OK: `accessToken`, `refreshToken`(회전됨, Keychain에 보관)

### POST /auth/logout — 로그아웃
저장된 리프레시 토큰을 폐기하고 쿠키를 지운다.
응답 200 — OK: any

### POST /auth/apple — Apple 네이티브 로그인
iOS가 받은 authorization code와 identity token을 서버에서 다시 검증한 뒤 서비스 JWT를 발급한다. iOS는 로그인마다 안전한 새 rawNonce를 만들고 Apple 요청 nonce에 lowercase hex SHA-256(rawNonce)를 넣어야 한다.

요청 본문:
- `authorizationCode` 문자열 필수 — 일회성 교환이 재전송 방어다
- `identityToken` 문자열 필수 — 서버가 JWKS의 RS256 서명을 다시 검증한다
- `rawNonce` 문자열 필수 — 로그인마다 새로 만든 원문 nonce. 재사용하지 않는다
- `name` 문자열 선택 — Apple이 최초 동의 때 준 경우만 보낸다

응답 200 — OK: `accessToken`, `refreshToken`(회전됨, Keychain에 보관)

### POST /auth/kakao — Kakao 네이티브 로그인
iOS Kakao SDK가 받은 OIDC ID token과 로그인 요청에 사용한 원문 nonce를 서버에서 검증한 뒤 서비스 JWT와 프로필 등록 완료 여부를 반환한다.

요청 본문:
- `identityToken` 문자열 필수 — Kakao SDK가 발급한 OIDC ID token
- `nonce` 문자열 필수 — 로그인마다 새로 만들고 Kakao SDK 요청에도 사용한 원문 nonce. Apple의 `rawNonce`와 달리 해시하지 않은 원문을 그대로 보낸다

응답 200 — OK:
- `accessToken`, `refreshToken`(회전됨, Keychain에 보관)
- `profileCompleted` 불리언 선택 — 서비스 프로필 등록 완료 여부. false면 프로필 등록이 필요하다 (현재 클라이언트는 이 필드 대신 로그인 성공 후 `GET /users/me`를 다시 호출해서 판단함 — 추후 최적화 여지)

### GET /auth/me — 내 정보
인증 필요.
응답 200 — OK:
- `userId` 정수(int64) 선택
- `email` 문자열 선택 — 소셜 프로바이더가 준 이메일. 로그인마다 갱신된다
- `name` 문자열 선택 — 소셜 프로바이더가 준 이름. 닉네임과 다르다
- `provider` 문자열 선택 — GOOGLE | KAKAO | NAVER | APPLE
- `role` 문자열 선택 — ROLE_USER | ROLE_ADMIN

### DELETE /auth/me — 회원 탈퇴
Apple 사용자는 저장된 provider refresh token으로 Apple 연결을 해제한 뒤 계정을 비활성화한다. Apple 일시 장애 시 로컬 상태를 변경하지 않고 503을 반환하므로 재시도할 수 있다. 저장된 provider token이 없으면 로컬 탈퇴를 완료하고 수동 연결 해제가 필요한 성공 코드를 반환한다. Kakao 사용자는 서버가 Kakao 연결을 먼저 해제한 뒤 로컬 탈퇴를 확정한다.
응답 200 — OK: any

---

## Ranking — 피커 랭킹 · 내 포인트

### GET /users/me/points — 내 포인트와 순위
인증 필요. 순위가 아직 산정되지 않았으면 `ranking`이 null이다 — 배치가 최대 5분마다 매기므로 가입 직후가 그렇다.
응답 200 — OK: `userId`, `nickname`, `profileImageUrl`, `ranking`(int32, 선택), `point`(int64)

### GET /rankings — 전체 피커 랭킹
포인트가 높은 순서대로 노출한다. 무한 스크롤(10개 단위)이며 게스트도 볼 수 있다. 순위가 아직 산정되지 않은 회원은 목록에 오르지 않는다.

파라미터:
- `cursor` (query) 문자열 선택 — 이전 응답의 nextCursor. 없으면 첫 조각
- `size` (query) 정수(int32) 선택 — 조각 크기. 기본 10

응답 200 — OK:
- `content` 배열 선택 — `userId`, `nickname`, `profileImageUrl`, `ranking`(1위가 가장 앞), `point`
- `nextCursor` 문자열 선택 — null이면 마지막
- `hasNext` 불리언 선택

### GET /rankings/top — 인기 피커(TOP 5)
포인트가 높은 상위 피커를 노출한다. 게스트도 볼 수 있다. 포인트 보유자가 없으면 빈 배열이다 — 화면은 이때 "아직 TOP 피커가 존재하지 않아요"를 표시한다.

파라미터: `size` (query) 정수(int32) 선택 — 기본 5
응답 200 — OK: 배열 `userId`, `nickname`, `profileImageUrl`, `ranking`, `point`

---

## Grade — 등급 현황 · 기준

### GET /users/me/grade — 내 등급 조회
현재 등급과 누적 포인트·투표 횟수, 다음 등급까지의 달성률을 돌려준다. 포인트는 원장 합계이므로 지급 직후 값이 곧바로 반영된다(R-14). 등급은 내려가지 않는다(R-16).

응답 200 — OK:
- `level` 정수(int32) 선택 — 1~5
- `name` 문자열 선택
- `point` 정수(int64) 선택 — point_history 합계
- `voteCount` 정수(int64) 선택 — 재투표는 세지 않는다
- `nextGrade` 객체 선택 — 최고 등급이면 null
  - `level`, `name`, `requiredPoint`(int64), `requiredVoteCount`(int64)
- `achievementRate` 정수(int32) 선택 — 다음 등급까지 달성률 0~100

### GET /grades — 전체 등급 기준 조회
LV.1~LV.5의 승급 필요 조건을 낮은 등급부터 돌려준다.
응답 200 — OK: 배열 `level`, `name`, `requiredPoint`, `requiredVoteCount`

---

## Badge — 뱃지 현황 · 미션

### GET /users/me/badges — 내 뱃지 현황
획득·미획득 뱃지 전체와 수집 개수를 돌려준다. 미획득 뱃지도 이름은 보여주고 일러스트만 가리는 화면이라(§12.2) 미획득도 함께 내려간다.

응답 200 — OK:
- `collectedCount` 정수(int32) 선택
- `badges` 배열 선택 — 전체 뱃지(미획득 포함)
  - `code` 문자열 선택 — 안정 식별자
  - `name` 문자열 선택
  - `description` 문자열 선택 — 획득 조건 문구
  - `conditionType` 문자열 선택
  - `threshold` 정수(int64) 선택 — 목표값
  - `acquired` 불리언 선택

### GET /users/me/badges/missions — 미해제 미션 진행률
아직 달성하지 못한 미션을 계열마다 하나씩 돌려준다(§2.3). 누적 계열과 일일 계열에서 각각 가장 낮은 임계값을 고른다. 진행률은 퍼센트가 아니라 현재값/목표값 두 수다 — 화면이 "(0/10)"으로 쓴다. 다 채운 계열은 빠지고, 8종을 모두 얻으면 빈 배열이다.

응답 200 — OK: 배열 `code`, `description`, `conditionType`, `current`(int64), `goal`(int64)

---

## Post — 게시글 목록 · 상세

### GET /posts — 게시글 목록 조회
카테고리 필터와 정렬(최신순·인기순), 커서 기반 무한 스크롤. 게시글이 없으면 빈 배열이다.

파라미터:
- `category` (query) 문자열 선택 — 없으면 전체
- `sort` (query) 문자열 선택 — LATEST(기본) | POPULAR
- `cursor` (query) 문자열 선택
- `size` (query) 정수(int32) 선택 — 기본 10

응답 200 — OK:
- `content` 배열 선택
  - `id` 정수(int64) 선택
  - `type` 문자열 선택 — GENERAL | AGREE | A_B (현재 앱의 `VoteType`은 `.text`/`.forAgainst`/`.ab` — 매핑 필요)
  - `category` 문자열 선택
  - `title` 문자열 선택 — 찬반=상품명, A/B=주제, 일반=제목
  - `description` 문자열 선택
  - `commentCount` 정수(int64) 선택
  - `voteCount` 정수(int64) 선택 — 일반 게시글은 null
  - `thumbnailUrl` 문자열 선택 — 대표 상품 사진 1장. 일반 게시글은 null
  - `createdAt` 문자열(date-time) 선택
  - `authorId` 정수(int64) 선택
  - `authorNickname` 문자열 선택
  - `authorRanking` 정수(int32) 선택 — 아직 산정되지 않았으면 null(최대 5분 지연)
- `nextCursor` 문자열 선택
- `hasNext` 불리언 선택

> 게시글 상세(GET /posts/{postId}) 단일 조회 엔드포인트는 이 문서에 없음 — 확인 필요.
> 게시글 작성(POST /posts) 엔드포인트도 이 문서에 없음 — 확인 필요.

---

## 주요 설계 규칙 (요구사항 정의서 참조 번호)

- **R-22 재투표 지원**: 이미 투표한 선택을 바꿔도 인원 증가 안 함
- **R-05/R-06 원픽 일회성**: 한 사람은 게시글당 댓글 1개만 원픽, 취소·변경 불가
- **R-13**: 원픽 id가 포인트 지급의 멱등키
- **R-14**: 포인트는 원장 합계, 지급 즉시 반영
- **R-16 등급 하향 불가**: 포인트 손실 후에도 등급 유지
- **비동기 랭킹**: 최대 5분 지연으로 배치 계산

## 아직 이 문서에 없는 것 (구현 전 백엔드 팀에 확인 필요)

- 게시글 상세 단일 조회, 게시글 작성/수정/삭제
- 신고/차단 관련 엔드포인트
