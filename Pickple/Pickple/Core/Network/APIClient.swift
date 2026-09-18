//
//  APIClient.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  각 도메인 Repository가 공통으로 쓰는 통신 도구.
//  요청 조립·인증 헤더 부착·{code,message,returnObject} 봉투 해석을 여기서만 처리한다.

import Foundation

protocol APIClientProtocol: Sendable {
    // returnObject가 있는 응답 (일반적인 조회/생성 등)
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    // returnObject를 쓰지 않는 응답 (로그아웃, 삭제 등)
    func requestVoid(_ endpoint: APIEndpoint) async throws
    // accessToken이 실제로 만료되기 전에 미리 재발급을 시도한다(프로액티브 리프레시).
    // 리프레시 토큰이 없거나 서버가 거부해도 조용히 넘어간다 — 그땐 실제 요청이 401을
    // 맞았을 때의 반응형 재발급 경로가 다시 처리한다.
    func refreshAccessTokenProactively() async
    // 재발급이 완전히 실패했을 때(리프레시 토큰까지 무효) 호출할 콜백을 등록한다.
    // AppSessionViewModel이 이걸로 로그인 화면 전환을 트리거한다.
    @MainActor
    func setSessionExpiredHandler(_ handler: @escaping @MainActor () -> Void)
}

// 모든 저장 프로퍼티가 let이고 URLSession·JSONDecoder·AccessTokenProviding(actor) 모두 동시성에 안전해 @unchecked Sendable로 선언한다.
final class APIClient: APIClientProtocol, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession
    private let tokenProvider: AccessTokenProviding
    private let decoder: JSONDecoder
    private let tokenRefresher: TokenRefresher?

    init(
        baseURL: URL,
        session: URLSession = .shared,
        tokenProvider: AccessTokenProviding,
        tokenStore: InMemoryTokenStore? = nil,
        refreshTokenStore: RefreshTokenStoring? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Self.decodeFlexibleDate)
        self.decoder = decoder

        // tokenStore/refreshTokenStore를 둘 다 받았을 때만 401 자동 재발급을 켠다 — 로그인
        // 전 임시 APIClient(APIClientEnvironment 기본값 등)처럼 갱신이 의미 없는 곳에서는 nil로 둔다.
        if let tokenStore, let refreshTokenStore {
            self.tokenRefresher = TokenRefresher(refreshTokenStore: refreshTokenStore, tokenStore: tokenStore) { [decoder, baseURL, session] (refreshToken: String) async throws -> AuthTokens in
                let body = try JSONEncoder().encode(MobileRefreshRequestDTO(refreshToken: refreshToken))
                let endpoint = APIEndpoint(method: .post, path: "/auth/mobile/refresh", body: body, requiresAuth: false)
                let (data, httpResponse) = try await Self.rawSend(endpoint, baseURL: baseURL, session: session, token: nil)
                // send()와 달리 이 클로저는 상태코드를 안 보고 바로 AuthTokensDTO로 디코딩하려 했다 —
                // 리프레시 토큰이 만료/무효라 서버가 에러 상태코드로 {code, message, returnObject: null}을
                // 내려주면, non-optional인 AuthTokensDTO 디코딩이 실패해 서버가 준 진짜 이유(code/message)
                // 대신 DecodingError만 보였다.
                guard (200..<300).contains(httpResponse.statusCode) else {
                    if let meta = try? decoder.decode(APIEnvelopeMeta.self, from: data) {
                        throw APIError.server(code: meta.code, message: meta.message)
                    }
                    throw APIError.server(code: "HTTP_\(httpResponse.statusCode)", message: "토큰 재발급이 실패했습니다")
                }
                let dto = try decoder.decode(APIEnvelope<AuthTokensDTO>.self, from: data).returnObject
                return AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }
        } else {
            self.tokenRefresher = nil
        }
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let (data, _) = try await send(endpoint)
        do {
            return try decoder.decode(APIEnvelope<T>.self, from: data).returnObject
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        _ = try await send(endpoint)
    }

    func refreshAccessTokenProactively() async {
        _ = try? await tokenRefresher?.refreshedAccessToken()
    }

    @MainActor
    func setSessionExpiredHandler(_ handler: @escaping @MainActor () -> Void) {
        tokenRefresher?.onRefreshFailed = handler
    }

    // 요청을 만들어 보내고, 성공(2xx)이면 응답 데이터를 그대로 돌려준다. 실패면 서버가 준 code/message를 담아 던진다.
    // 401을 받으면(토큰을 실었던 요청에 한해) accessToken을 한 번 재발급받고 그 요청만 재시도한다 —
    // 그래서 앱을 오래 켜둬서 토큰이 만료돼도 다시 로그인할 때까지 모든 요청이 조용히 실패하지 않는다.
    private func send(_ endpoint: APIEndpoint, isRetry: Bool = false) async throws -> (Data, HTTPURLResponse) {
        var token: String?
        if endpoint.requiresAuth {
            guard let requiredToken = await tokenProvider.accessToken() else {
                throw APIError.unauthorized
            }
            token = requiredToken
        } else if endpoint.attachesAuthIfAvailable {
            token = await tokenProvider.accessToken()
        }

        let (data, httpResponse) = try await Self.rawSend(endpoint, baseURL: baseURL, session: session, token: token)

        guard (200..<300).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                if !isRetry, token != nil, let tokenRefresher, (try? await tokenRefresher.refreshedAccessToken()) != nil {
                    return try await send(endpoint, isRetry: true)
                }
                throw APIError.unauthorized
            }
            if let meta = try? decoder.decode(APIEnvelopeMeta.self, from: data) {
                throw APIError.server(code: meta.code, message: meta.message)
            }
            throw APIError.server(code: "HTTP_\(httpResponse.statusCode)", message: "요청이 실패했습니다")
        }

        return (data, httpResponse)
    }

    // send()의 순수 HTTP 부분(요청 조립 + 전송)만 떼어낸 static 버전 — TokenRefresher에 넘기는
    // 재발급 클로저가 init 시점에 만들어지는데, 그 안에서 self의 인스턴스 메서드(send)를 쓰면
    // "self가 아직 다 초기화되지 않았다"는 제약에 걸려서 정적으로 필요한 값만 받아 처리한다.
    private static func rawSend(_ endpoint: APIEndpoint, baseURL: URL, session: URLSession, token: String?) async throws -> (Data, HTTPURLResponse) {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let files = endpoint.multipartFiles, !files.isEmpty {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = Self.multipartBody(files: files, boundary: boundary)
        } else {
            request.httpBody = endpoint.body
            if endpoint.body != nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(String(describing: error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.transport("HTTPURLResponse가 아님")
        }

        return (data, httpResponse)
    }

    // 서버 응답의 날짜 형식이 밀리초 유무·타임존 유무로 섞여 있어서(예: 스프링 부트가 흔히
    // 쓰는 타임존 없는 LocalDateTime 직렬화 "yyyy-MM-ddTHH:mm:ss"), 여러 형식을 순서대로
    // 시도한다. 타임존이 없는 형식은 UTC가 아니라 KST(Asia/Seoul)로 간주한다 — 한국 서비스라
    // 서버 로컬 시간이 KST일 가능성이 높고, UTC로 잘못 간주하면 표시 시각이 9시간 밀린다.
    // JSONDecoder.dateDecodingStrategy(.custom)가 기대하는 클로저 타입은 격리가 없는 동기
    // 함수라, -default-isolation=MainActor 기본값과 안 맞아 아래 decodeFlexibleDate와
    // 포매터들 모두 명시적으로 격리를 벗어나야 한다. 이 SDK에서 DateFormatter는 Sendable을
    // 채택했지만 ISO8601DateFormatter는 아니라서, 전자는 nonisolated만으로 충분하고
    // 후자는 nonisolated(unsafe)로 우회해야 한다 — 둘 다 설정 후 값이 안 바뀌는 불변
    // 객체라 어느 쪽이든 여러 컨텍스트에서 읽기만 해도 안전하다.
    nonisolated(unsafe) private static let iso8601WithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    nonisolated(unsafe) private static let iso8601Plain: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    nonisolated private static let noTimezoneWithFractional: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()

    nonisolated private static let noTimezonePlain: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    nonisolated private static func decodeFlexibleDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let date = iso8601WithFractional.date(from: dateString) { return date }
        if let date = iso8601Plain.date(from: dateString) { return date }
        if let date = noTimezoneWithFractional.date(from: dateString) { return date }
        if let date = noTimezonePlain.date(from: dateString) { return date }
        // 소수점 초 자릿수가 위 어느 것과도 안 맞으면, 앞 19자("yyyy-MM-ddTHH:mm:ss")만
        // 잘라서 마지막으로 시도한다.
        if dateString.count > 19, let date = noTimezonePlain.date(from: String(dateString.prefix(19))) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Expected date string to be ISO8601-formatted."
        )
    }

    private static func multipartBody(files: [MultipartFile], boundary: String) -> Data {
        var body = Data()
        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
