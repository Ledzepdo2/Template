import Foundation
import Dependencies
import Alamofire

public struct NetworkingClient: Sendable {
    public let getJSON: @Sendable (_ url: URL) async throws -> Data

    public init(getJSON: @escaping @Sendable (_ url: URL) async throws -> Data) {
        self.getJSON = getJSON
    }
}

public extension NetworkingClient {
    static let live = NetworkingClient { url in
        try await withCheckedThrowingContinuation { continuation in
            AF.request(url).validate().responseData { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    static let preview = NetworkingClient { _ in
        Data("{\"items\":[]}".utf8)
    }
}

private enum NetworkingClientKey: DependencyKey {
    static let liveValue: NetworkingClient = .live
    static let previewValue: NetworkingClient = .preview
    static let testValue: NetworkingClient = NetworkingClient { _ in
        throw URLError(.badURL)
    }
}

public extension DependencyValues {
    var networkingClient: NetworkingClient {
        get { self[NetworkingClientKey.self] }
        set { self[NetworkingClientKey.self] = newValue }
    }
}
