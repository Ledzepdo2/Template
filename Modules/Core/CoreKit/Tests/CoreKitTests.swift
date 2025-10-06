import XCTest
import MacroTesting
@testable import CoreKit

@MainActor
final class CoreKitTests: XCTestCase {
    func testConfigurationRegistersDependencies() {
        let config = AppConfiguration(environment: .testing)
        config.register()
        #expect(AppConfiguration.current.environment == .testing)
    }
}
