import Foundation
import CoreKit

final class AppBootstrap {
    static let shared = AppBootstrap()

    private let configuration = AppConfiguration()
    private init() {}

    func start() {
        configuration.register()
    }

    func logStartup() {
        configuration.logger.info("🚀 {{ProjectName}} started with environment \(configuration.environment.rawValue)")
    }
}
