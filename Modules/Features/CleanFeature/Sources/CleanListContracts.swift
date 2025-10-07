import Foundation
import Dependencies
import CoreKit

public protocol CleanListBusinessLogic: AnyObject {
    func load(request: CleanListModels.Request) async
    func refresh(request: CleanListModels.Request) async
}

@MainActor
public protocol CleanListPresentationLogic: AnyObject {
    func present(response: CleanListModels.Response)
}

@MainActor
public protocol CleanListDisplayLogic: AnyObject {
    func display(viewModel: [CleanListModels.ViewModel])
}

public protocol CleanListWorkerProtocol: Sendable {
    func fetchItems() async throws -> [CleanListModels.Item]
}

public struct CleanListWorker: CleanListWorkerProtocol {
    @Dependency(\.networkingClient) private var networkingClient
    @Dependency(\.logger) private var logger

    public init() {}

    public func fetchItems() async throws -> [CleanListModels.Item] {
        let url = URL(string: "https://mockjson.com/api/v1/items")!
        let data = try await networkingClient.getJSON(url)
        let payload = try JSONDecoder().decode(APIResponse.self, from: data)
        logger.debug("Fetched CleanList payload with \(payload.items.count) entries")
        return payload.items.map { item in
            CleanListModels.Item(id: item.id, title: item.title, subtitle: item.subtitle)
        }
    }

    private struct APIResponse: Decodable {
        struct ItemDTO: Decodable {
            let id: UUID
            let title: String
            let subtitle: String
        }

        let items: [ItemDTO]
    }
}

extension CleanListWorker: @unchecked Sendable {}
