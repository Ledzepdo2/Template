import XCTest
import Foundation
import ComposableArchitecture
@testable import TCAFeature

final class TCACounterFeatureTests: XCTestCase {
    func testIncrementFlow() async {
        let store = TestStore(initialState: .init()) {
            TCACounterFeature()
        }
        store.dependencies.uuid = .incrementing

        await store.send(.incrementTapped) {
            $0.count = 1
        }

        await store.receive(.countUpdated(1)) {
            $0.history = [TCACounterFeature.State.Entry(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, value: 1)]
        }
    }
}
