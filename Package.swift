// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppReviewRequest",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [
        .library(
            name: "AppReviewRequestUI",
            targets: ["AppReviewRequestUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
        .package(url: "https://github.com/Ausianovich/AppGlobalState.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AppReviewRequest",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AppGlobalState", package: "AppGlobalState"),
            ]
        ),
        .testTarget(
            name: "AppReviewRequestTests",
            dependencies: ["AppReviewRequest", "AppReviewRequestUI"]
        ),
        .target(
            name: "AppReviewRequestUI",
            dependencies: [
                "AppReviewRequest",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AppGlobalState", package: "AppGlobalState"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
