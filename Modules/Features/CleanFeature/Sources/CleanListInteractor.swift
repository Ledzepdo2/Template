import Foundation
import Dependencies

public final class CleanListInteractor: CleanListBusinessLogic {
    private let presenter: CleanListPresentationLogic
    private let worker: CleanListWorkerProtocol
    @Dependency(\.logger) private var logger

    public init(presenter: CleanListPresentationLogic,
                worker: CleanListWorkerProtocol = CleanListWorker()) {
        self.presenter = presenter
        self.worker = worker
    }

    public func load() {
        Task { await loadItems() }
    }

    public func refresh() {
        Task { await loadItems() }
    }

    private func loadItems() async {
        do {
            let items = try await worker.fetchItems()
            presenter.present(response: .init(items: items))
        } catch {
            logger.error("CleanListInteractor error: \(error.localizedDescription)")
            presenter.present(response: .init(items: []))
        }
    }
}
