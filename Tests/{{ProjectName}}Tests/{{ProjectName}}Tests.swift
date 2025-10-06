import XCTest
import ComposableArchitecture
@testable import MVVMFeature
@testable import CleanFeature
@testable import TCAFeature

final class {{ProjectName}}Tests: XCTestCase {
    @MainActor
    func testMVVMLoader() async throws {
        let viewModel = MVVMLoaderViewModel(imageURL: nil)
        await viewModel.loadImage()
        XCTAssertNil(await MainActor.run { viewModel.imageState.image })
    }

    func testCleanInteractor() async {
        let presenter = SpyPresenter()
        let interactor = CleanListInteractor(presenter: presenter, worker: MockWorker())
        interactor.load()
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(presenter.presentCalls.count, 1)
    }

    @MainActor
    func testTCAReducer() async {
        let store = TCACounterStore.testStore
        await store.send(.incrementTapped)
        await store.receive(.countUpdated(1))
    }
}

private final class SpyPresenter: CleanListPresentationLogic {
    var presentCalls: [CleanListModels.Response] = []

    func present(response: CleanListModels.Response) {
        presentCalls.append(response)
    }
}

private struct MockWorker: CleanListWorkerProtocol {
    func fetchItems() async throws -> [CleanListModels.Item] {
        [.init(id: UUID(), title: "Test", subtitle: "Subtitle")]
    }
}
