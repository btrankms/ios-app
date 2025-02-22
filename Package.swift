// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ios-app",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ios-app",
            targets: ["ios-app"])
    ],
    dependencies: [
        .package(url: "https://github.com/danielgindi/Charts.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "ios-app",
            dependencies: [
                .product(name: "DGCharts", package: "Charts")
            ],
            path: "src")
    ]
)