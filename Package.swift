// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "EFAAPI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "EFAAPI",
            targets: ["EFAAPI"]
        ),
        .library(
            name: "EFAUI",
            targets: ["EFAUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/LambdaDigamma/ModernNetworking.git", from: "0.1.2"),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.13.1")
    ],
    targets: [
        .target(
            name: "EFAAPI",
            dependencies: ["XMLCoder", "ModernNetworking"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "EFAUI",
            dependencies: ["EFAAPI"]
        ),
        .testTarget(
            name: "EFAAPITests",
            dependencies: ["EFAAPI"],
            resources: [
                .copy("Data")
            ]
        )
    ]
)
