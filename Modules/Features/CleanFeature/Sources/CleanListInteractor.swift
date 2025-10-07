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
        scheduleLoad()
    }

    public func refresh() {
        scheduleLoad()
    }

    private func scheduleLoad() {
        let worker = self.worker
        let logger = self.logger

        Task.detached(priority: nil) { [worker, logger, weak self] in
            guard let self else { return }
            do {
                let items = try await worker.fetchItems()
                await MainActor.run {
                    self.presenter.present(response: .init(items: items))
                }
            } catch {
                logger.error("CleanListInteractor error: \(error.localizedDescription)")
                await MainActor.run {
                    self.presenter.present(response: .init(items: []))
                }
            }
        }
    }
}
