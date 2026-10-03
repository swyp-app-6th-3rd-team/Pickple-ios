//
//  AnalyticsService
//  Pickple
//
//  Created by 박윤수 on 9/30/26.
//
//
/*
 ┌──────────────────────────┬───────────────────────────────────────────────┐
 │           옵션           │                  잡는 이벤트                      │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │ .sessions                │ 세션 시작/종료. 같은 세션의 모든 이벤트에               │
 │                          │ session_id를 자동으로 붙여줌                       │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │                          │ Application Installed(최초 설치), Application.   │
 │ .appLifecycles           │  Updated(업데이트 후 첫 실행), Application         │
 │                          │ Opened(재실행/포그라운드 복귀), Application          │
 │                          │ Backgrounded(백그라운드 진입)                      │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │ .screenViews             │ 화면 전환 시 Screen Viewed 이벤트, 화면       │
 │                          │ 이름은 최상단 뷰 컨트롤러의 클래스 이름       │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │ .elementInteractions     │ 버튼 클릭 등 UI 요소 상호작용 시 Element      │
 │                          │ Interacted 이벤트                             │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │ .networkTracking         │ 네트워크 요청 자동 감지, Network Request      │
 │                          │ 이벤트 (기본은 500~599 에러 상태코드만)       │
 ├──────────────────────────┼───────────────────────────────────────────────┤
 │                          │ Rage Click(1초 안에 같은 요소 4번 이상 클릭 — │
 │ .frustrationInteractions │  답답해서 연타), Dead Click(눌렀는데 3초간    │
 │                          │ 아무 반응 없음)                               │
 └──────────────────────────┴───────────────────────────────────────────────┘
 */
import Foundation
import AmplitudeSwift

enum AnalyticsService {
    static let shared: Amplitude = {
        guard let apiKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String else {
            fatalError("Info.plist에 AMPLITUDE_API_KEY가 없습니다 — Config.xcconfig 설정을 확인하세요")
        }
        return Amplitude(configuration: Configuration(
            apiKey: apiKey,
            trackingOptions: TrackingOptions()
                .disableTrackCarrier()
                .disableTrackIpAddress()
                .disableTrackCity()
                .disableTrackRegion()
                .disableTrackDMA()
                .disableTrackCountry()
                .disableTrackLanguage(),
            autocapture: [.sessions]
        ))
    }()
    
    static func track(_ eventName: String, properties: [String: Any] = [:]) {
        shared.track(eventType: eventName, eventProperties: properties)
    }
}
