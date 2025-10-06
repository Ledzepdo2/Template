import Foundation
import Dependencies
import Logging

public final class AppConfiguration {
    public enum Environment: String {
        case debug
        case release
        case testing
    }

    public let environment: Environment
    public let logger: Logger

    public init(environment: Environment = .debug,
                logger: Logger = Logger(label: "{{ProjectName}}")) {
        self.environment = environment
        self.logger = logger
    }

    public func register() {
        AppConfigurationStorage.shared = self
        logger.info("Registering dependencies for environment: \(environment.rawValue)")
    }

    public static var current: AppConfiguration {
        AppConfigurationStorage.shared
    }
}

private enum AppConfigurationStorage {
    static var shared = AppConfiguration()
}

private enum LoggerKey: DependencyKey {
    static let liveValue: Logger = AppConfigurationStorage.shared.logger
}

private enum AppConfigurationKey: DependencyKey {
    static let liveValue: AppConfiguration = AppConfigurationStorage.shared
}

public extension DependencyValues {
    var logger: Logger {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }

    var appConfiguration: AppConfiguration {
        get { self[AppConfigurationKey.self] }
        set { self[AppConfigurationKey.self] = newValue }
    }
}
