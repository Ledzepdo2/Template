import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies
import CasePaths
import IdentifiedCollections
import CoreKit

public struct TCACounterFeature: Reducer {
    public struct State: Equatable {
        public var count: Int = 0
        public var history: IdentifiedArrayOf<Entry> = []

        public struct Entry: Identifiable, Equatable {
            public var id: UUID
            public var value: Int
        }

        public init() {}
    }

    public enum Action: Equatable {
        case incrementTapped
        case decrementTapped
        case countUpdated(Int)
        case historyItemTapped(UUID)
    }

    @Dependency(\.logger) private var logger
    @Dependency(\.uuid) private var uuid

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementTapped:
                state.count += 1
                logger.info("Counter incremented to \(state.count)")
                return .send(.countUpdated(state.count))

            case .decrementTapped:
                state.count -= 1
                logger.notice("Counter decremented to \(state.count)")
                return .send(.countUpdated(state.count))

            case let .countUpdated(value):
                let entry = State.Entry(id: uuid(), value: value)
                state.history.insert(entry, at: 0)
                return .none

            case let .historyItemTapped(id):
                guard let item = state.history[id: id] else { return .none }
                state.count = item.value
                return .send(.countUpdated(item.value))
            }
        }
    }
}

public struct TCACounterView: View {
    let store: StoreOf<TCACounterFeature>

    public init(store: StoreOf<TCACounterFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Text("Count: \(viewStore.count)")
                    .font(.largeTitle.bold())

                HStack {
                    Button("-") { viewStore.send(.decrementTapped) }
                        .buttonStyle(.borderedProminent)
                    Button("+") { viewStore.send(.incrementTapped) }
                        .buttonStyle(.borderedProminent)
                }

                List(viewStore.history) { item in
                    Button(action: { viewStore.send(.historyItemTapped(item.id)) }) {
                        HStack {
                            Text("→ \(item.value)")
                            Spacer()
                            Text(item.id.uuidString.prefix(4))
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.inset)
            }
            .padding()
        }
    }
}

public enum TCACounterStore {
    public static var live: StoreOf<TCACounterFeature> {
        Store(initialState: .init()) {
            TCACounterFeature()
        }
    }

    @MainActor
    public static var testStore: TestStore<TCACounterFeature.State, TCACounterFeature.Action> {
        TestStore(initialState: .init()) {
            TCACounterFeature()
        }
    }
}
