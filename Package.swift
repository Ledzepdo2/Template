// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "{{ProjectName}}Modules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "MVVMFeature", targets: ["MVVMFeature"]),
        .library(name: "CleanFeature", targets: ["CleanFeature"]),
        .library(name: "TCAFeature", targets: ["TCAFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "0.14.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections.git", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.3.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.4"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.4"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.5.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.10.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.40.0"),
        .package(url: "https://github.com/launchdarkly/ios-client-sdk.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CoreKit",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Logging", package: "swift-log")
            ],
            path: "Modules/Core/CoreKit/Sources"
        ),
        .testTarget(
            name: "CoreKitTests",
            dependencies: [
                "CoreKit",
                .product(name: "MacroTesting", package: "swift-macro-testing")
            ],
            path: "Modules/Core/CoreKit/Tests"
        ),
        .target(
            name: "MVVMFeature",
            dependencies: [
                "CoreKit",
                .product(name: "Nuke", package: "Nuke")
            ],
            path: "Modules/Features/MVVMFeature/Sources"
        ),
        .testTarget(
            name: "MVVMFeatureTests",
            dependencies: [
                "MVVMFeature"
            ],
            path: "Modules/Features/MVVMFeature/Tests"
        ),
        .target(
            name: "CleanFeature",
            dependencies: [
                "CoreKit",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Lottie", package: "lottie-ios")
            ],
            path: "Modules/Features/CleanFeature/Sources"
        ),
        .testTarget(
            name: "CleanFeatureTests",
            dependencies: [
                "CleanFeature"
            ],
            path: "Modules/Features/CleanFeature/Tests"
        ),
        .target(
            name: "TCAFeature",
            dependencies: [
                "CoreKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "CasePaths", package: "swift-case-paths"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ],
            path: "Modules/Features/TCAFeature/Sources"
        ),
        .testTarget(
            name: "TCAFeatureTests",
            dependencies: [
                "TCAFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Modules/Features/TCAFeature/Tests"
        )
    ]
)
