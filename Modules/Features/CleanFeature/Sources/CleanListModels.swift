import Foundation

public enum CleanListModels {
    public struct Request {
        public init() {}
    }

    public struct Response {
        public let items: [Item]
        public init(items: [Item]) {
            self.items = items
        }
    }

    public struct ViewModel: Identifiable {
        public let id: UUID
        public let title: String
        public let subtitle: String
    }

    public struct Item: Identifiable, Equatable {
        public let id: UUID
        public let title: String
        public let subtitle: String

        public init(id: UUID, title: String, subtitle: String) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
        }
    }
}
