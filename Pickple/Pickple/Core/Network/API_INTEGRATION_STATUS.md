# API 연동 현황

`API_SPEC.md`가 "서버가 뭘 주고받는지"에 대한 문서라면, 이 문서는 "그중 우리 앱이 실제로 뭘 연동했는지"에 대한 스냅샷이다. 레포지토리(`Domain/Repository/*`)를 하나씩 실 API로 바꿀 때마다 이 문서를 갱신할 것.

## 연동 완료

### 인증 (`AuthRepository` / `RemoteAuthRepository`)
- Apple 로그인 — `POST /auth/apple`
- 자동 로그인(세션 복원) — `POST /auth/mobile/refresh`
- 로그아웃 — `POST /auth/logout`
- 회원 탈퇴 — `DELETE /auth/me`

### 프로필 (`ProfileRepository` / `RemoteProfileRepository`)
- 프로필 조회 — `GET /users/me` (닉네임 등록 여부 판단용)
- 프로필 등록 — `POST /users/profile` (닉네임만. 이미지는 안 보냄 — 아래 "아직 안 한 것" 참고)

### 뱃지 (`BadgeMissionRepository`/`MyBadgeRepository` → `RemoteBadgeMissionRepository`/`RemoteMyBadgeRepository`)
- 미해제 미션 — `GET /users/me/badges/missions`
- 내 뱃지 현황 — `GET /users/me/badges`

> ⚠️ 뱃지 `code`(예: `TOTAL_VOTE_10`) → 아이콘 에셋 매핑은 문서에 확인된 예시가 하나뿐이라 나머지는 추정치다. 실제 로그인 응답으로 code 값 확인 필요 — `RemoteBadgeMissionRepository.badgeIconOffName(forMissionCode:)` 참고.

## 아직 안 한 것 — API는 있음, 연동만 안 함

| 화면/기능 | 엔드포인트 | 관련 Domain 레포지토리 |
|---|---|---|
| 전체/TOP 피커 랭킹 | `GET /rankings`, `GET /rankings/top` | `PickerRankingRepository` (cursor 타입이 지금 `Int`인데 실제로는 `String` — 시그니처 변경 필요) |
| 내가 올린 최근 투표 | `GET /users/me/posts/recent` | `UserPostRepository` (일부만 대응, 아래 참고) |
| 내 활동 목록/요약 | `GET /users/me/activities`, `GET /users/me/activities/summary` | `UserInfoRepository`(조합 필요) |
| 내 포인트·랭킹 | `GET /users/me/points` | `UserInfoRepository`(조합 필요) |
| 내 등급 / 전체 등급 기준 | `GET /users/me/grade`, `GET /grades` | `UserInfoRepository`(조합 필요) |
| 게시글 목록 / 인기 게시글 | `GET /posts`, `GET /posts/popular` | `CommunityRepository`, `VoteCardRepository` |
| 댓글 목록/작성/수정/삭제/원픽 | `GET·POST /posts/{postId}/comments`, `PATCH·DELETE /comments/{id}`, `POST /comments/{commentId}/pick` | `CommentRepository` (지금 `fetchComments()`에 `postId` 파라미터 자체가 없음 — 추가 필요) |
| 투표 참여 | `POST /posts/{postId}/votes` | — |
| 닉네임 중복 확인 | `GET /users/nickname/availability` | `ProfileViewModel.isNicknameValid()`에 TODO로 남아있음 |
| 프로필 이미지 업로드 | `POST /images` | `ProfileRepository` (스펙에 있는 걸 늦게 확인함 — 프로필 이미지 붙일 때 이걸로) |

`UserInfoRepository.fetchUserInfo()`는 지금 `UserInfo` 구조체 하나에 닉네임/포인트/레벨/투표수/댓글수/게시글수를 다 담고 있는데, 이걸 실제 API로 채우려면 위 표의 여러 엔드포인트(`/users/me` + `/users/me/points` + `/users/me/grade` + `/users/me/activities/summary`)를 조합해서 응답해야 한다 — 단일 엔드포인트로는 안 됨.

## 못하는 것 — API 자체가 스펙에 없음

- **게시글 상세 단일 조회** (`GET /posts/{postId}`) — 목록/댓글/투표 하위 리소스는 있는데 게시글 하나를 조회하는 엔드포인트가 없다. `PostDetailRepository` 연동 불가.
- **게시글 작성/수정/삭제** (`POST/PATCH/DELETE /posts`) — 전혀 없다. `PostWriteFlow`는 UI만 있고 저장할 API가 없는 상태.
- **마이페이지 필터별 게시글 목록** — `UserPostRepository`의 `fetchVotedPosts`/`fetchCommentedPosts`/`fetchWrittenPosts`("내가 투표한/댓글단/작성한 글" 각각 조회)에 대응하는 엔드포인트가 없다. `/users/me/posts/recent`는 별개로 "최근 7일 이내 투표 게시글"만 준다.
- **카카오 로그인** — `API_SPEC.md`에도 "Kakao 로그인 엔드포인트는 이 문서에 없음 — 확인 필요"라고 명시돼 있음.

게시글 작성/상세/마이페이지 필터 목록은 이 앱의 핵심 기능인데 API 자체가 없는 상태라, 백엔드팀에 우선순위 높게 확인이 필요하다.
