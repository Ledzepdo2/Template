import XCTest
@testable import CleanFeature

final class CleanListInteractorTests: XCTestCase {
    func testInteractorNotifiesPresenter() async {
        let presenter = PresenterSpy()
        let worker = WorkerStub(items: [.init(id: UUID(), title: "Hello", subtitle: "World")])
        let interactor = CleanListInteractor(presenter: presenter, worker: worker)

        interactor.load()
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(presenter.responses.count, 1)
        XCTAssertEqual(presenter.responses.first?.items.count, 1)
    }
}

private final class PresenterSpy: CleanListPresentationLogic {
    var responses: [CleanListModels.Response] = []
    func present(response: CleanListModels.Response) {
        responses.append(response)
    }
}

private struct WorkerStub: CleanListWorkerProtocol {
    let items: [CleanListModels.Item]
    func fetchItems() async throws -> [CleanListModels.Item] { items }
}
