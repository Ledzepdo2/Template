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

    public func load(request: CleanListModels.Request) async {
        await performLoad()
    }

    public func refresh(request: CleanListModels.Request) async {
        await performLoad()
    }

    private func performLoad() async {
        do {
            let items = try await worker.fetchItems()
            await presenter.present(response: .init(items: items))
        } catch {
            logger.error("CleanListInteractor error: \(error.localizedDescription)")
            await presenter.present(response: .init(items: []))
        }
    }
}
