// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Suspense",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Suspense",
            targets: ["Suspense"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Suspense"
        ),
        .testTarget(
            name: "SuspenseTests",
            dependencies: [
                "Suspense",
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ]
)
