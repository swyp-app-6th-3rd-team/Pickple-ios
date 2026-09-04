# 구조 문서

`CLAUDE.md`가 지켜야 할 규칙이라면, 이 문서는 지금 코드가 실제로 어떻게 짜여있는지에 대한 스냅샷이다. 코드가 바뀌면 이 문서도 갱신할 것.

## 레이어

```
Domain      → Entities(순수 값 타입) + Repository 프로토콜. 서버/UI 어느 쪽에도 의존하지 않는다.
Data        → Domain의 Repository 프로토콜을 구현하는 Mock 레포지토리들.
              실제 API 연동 전까지는 전부 여기서 목업 데이터를 만들어 돌려준다.
Presentation → 화면별 폴더. View + ViewModel이 같은 폴더에 있다(co-location).
Core        → 화면 하나에 속하지 않는 공용 인프라(Router 베이스, Extension 등).
```

`Data/Repository`는 전에 `Repositary`로 오타가 나 있었는데 수정했다(2026-09-04). Xcode 프로젝트가 `PBXFileSystemSynchronizedRootGroup`(폴더 자동 동기화) 방식이라 `.pbxproj`를 안 건드리고 디렉토리만 옮겨도 된다.

## Presentation 폴더 구성

화면 단위로 폴더가 나뉘어 있다: `Main`(+ `CardStackView`/`HotPost`/`Mission`/`Ranking` 하위), `Community`, `MyPage`(+ `Extra`/`Info`/`Post`/`Profile`/`Status` 하위), `MyAccount`, `MyActivity`, `MyBadge`, `MyGrade`, `Post`(+ `PostDetail`/`Steps` 하위), `Login`, `DesignSystem`(공용 컴포넌트).

**뷰가 50줄을 넘거나 다른 파일에서도 쓰이면 분리한다**(CLAUDE.md 규칙). 화면 하나가 커지면 `PostDetailView.swift`처럼 View 자체 + 그 화면에서만 쓰는 하위 뷰/타입이 한 파일에 뒤섞이기 쉬운데, 이번에 아래처럼 정리했다:

- `PostDetailView.swift` (346줄 → 225줄): `CarouselBottomKey`(PreferenceKey), `PostDetailConfirmAction`(enum), `PostDetailContent`(스크롤 본문)를 각각 별도 파일로 뺐다.
- `PostWriteFlowView.swift` (164줄): `PostWriteFlowStepContent`, `PostWriteFlowButtonRow`를 별도 파일로 뺐다.

기준: **화면의 최상위 진입점(NavigationDestination이 되는 View)만 `XxxView.swift`에 남기고, 그 화면에서만 쓰는 하위 조각도 각자 파일로.** private 접근제어자는 같은 파일 안에서만 의미가 있으므로, 분리하면서 `private` → 기본(internal)으로 바꿔야 한다.

## 네비게이션 — 두 패턴이 공존한다

**탭 루트(홈/커뮤니티/마이)**: `Router<Route>` 패턴. `Core/Navigation/Router.swift`에 제네릭 베이스가 있고, 각 탭이 얇게 상속한다:

```swift
final class MainRouter: Router<MainRoute> {}
final class CommunityRouter: Router<CommunityRoute> {}
final class MyPageRouter: Router<MyPageRoute> {}
```

`PickpleBottomNav.swift`가 탭마다 `NavigationStack(path: $xxxRouter.path)` + `.navigationDestination(for: XxxRoute.self)`로 route → 화면 매핑을 갖고, `.environment(xxxRouter)`로 심어서 하위 뷰는 `@Environment(XxxRouter.self)`로 받아 `router.push(.someRoute)`만 호출한다. (이 패턴을 도입한 이유와 설계는 PR #50 본문에 정리되어 있다.)

**그 외 화면 안에서의 이동**(수정 화면 진입, 탈퇴 확인 후 등): 기존 `@State private var navigatesToX = false` + `.navigationDestination(isPresented:)` 방식이 그대로 쓰인다. 예: `PostDetailView`의 수정 진입, `PostWriteFlowView`의 작성 완료 후 상세 이동, `MyAccountView`의 로그아웃/탈퇴 확인.

두 패턴이 섞여 있는 건 지금 Router 패턴으로 옮겨가는 중이라 자연스러운 상태다. 화면 하나에 목적지가 여러 개로 늘어나면(지금 `MainView`처럼) Router로 옮기는 걸 고려하고, 목적지가 1~2개뿐이면 기존 bool 패턴이 더 간단하다.

## ViewModel — 문서와 실제가 다른 지점

`CLAUDE.md`는 "`@Observable` 기반 MVVM"이라 명시하지만, 실제로 화면 ViewModel 10개는 전부 `ObservableObject` + `@Published`(Combine 기반)다. `@Observable`은 이번에 추가한 Router 3개뿐이다. iOS 17+ 타겟이라 `@Observable`로 전환 자체는 가능하지만, 기존 ViewModel 10개를 한 번에 옮기는 건 손댈 파일이 많고 UI 쪽 재검증이 필요해서 이번 정리 범위에 넣지 않았다. 새 ViewModel을 추가할 땐 `@Observable`을 쓰고, 기존 것들은 건드릴 일이 생겼을 때 그 김에 옮기는 정도가 현실적이다.

## 공용 컴포넌트 (`DesignSystem/Components`)

- **`PickpleGNB`**: 화면 상단 바(뒤로가기/타이틀/우측 액션). `tint`(아이콘·텍스트 색)와 `background`(배경색) 파라미터가 있다(기본값은 기존과 동일해서 대부분 화면엔 영향 없음). `PostDetailView`가 스크롤에 따라 이 둘을 동적으로 바꾸는 식으로 쓴다.
- **`PickpleDialogOverlay`**: 화면 전체를 덮는 반투명 배경 위에 중앙 모달을 띄우는 래퍼. `Color.black.opacity(0.4).ignoresSafeArea()`를 화면마다 반복 작성하던 걸 모았다. `onTapDismiss` 옵션으로 바깥 탭 시 닫기도 지원한다.
  - **주의**: `PickpleConfirmDialog`/`PostLeaveConfirmDialog`처럼 자체 좌우 패딩이 없는 모달만 그대로 끼워 넣을 수 있다. `MyAccountConfirmDialog`/`CommunityLoginRequiredModal`은 컴포넌트 자체에 `.padding(.horizontal, 40)`이 이미 들어있어서, `PickpleDialogOverlay`에 넣으면 패딩이 두 번 겹친다 — 그래서 `MyAccountView`/`CommunityView`는 아직 예전 방식(`Color.black.opacity(0.4)` 직접 작성) 그대로 남아있다.
- **확인 모달 4종류가 사실상 중복**(`PickpleConfirmDialog`, `MyAccountConfirmDialog`, `PostLeaveConfirmDialog`, `CommunityLoginRequiredModal`): 구조는 거의 동일하고 색상/폰트 크기만 미세하게 다르다. 하나로 합칠 수 있지만 "어느 스타일이 정답인지" 고르는 게 UI 판단이라 이번엔 손대지 않았다.

## Mock Repository

`Data/Repository/MockXxxRepository.swift`들이 `Domain/Repository`의 프로토콜을 구현한다. 실제 API 붙기 전까지는 이 목업들이 데이터 소스 전부다. `PostSummary(...)` 같은 12개 필드짜리 리터럴이 파일마다 여러 번 반복 타이핑되어 있는데, 실 API 연동 시 자연히 없어질 코드라 지금 정리 우선순위는 낮게 잡았다.

## 알고 있지만 이번에 안 건드린 것

- **확인 모달 4종 통합** — 위 참고. UI 스타일 판단 필요.
- **ViewModel 전체 `@Observable` 전환** — 범위가 크고 UI 재검증 필요.
- **네비게이션 두 패턴 통일** — 아직 자연스러운 과도기.
- **Mock 데이터 리터럴 중복** — 실 API 연동 때 자연 소멸.
