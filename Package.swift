// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ios-app",
    platforms: [
        .iOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/danielgindi/Charts.git", .upToNextMajor(from: "4.1.0"))
    ],
    targets: [
        .target(
            name: "ios-app",
            dependencies: ["Charts"],
            path: "src"
        )
    ]
)