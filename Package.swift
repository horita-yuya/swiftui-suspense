// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Suspense",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "Suspense",
            targets: ["Suspense"]
        )
    ],
    targets: [
        .target(
            name: "Suspense"
        ),
        .testTarget(
            name: "SuspenseTests",
            dependencies: ["Suspense"]
        ),
    ]
)
