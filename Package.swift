// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EFAAPI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
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
        ),
        .executable(
            name: "EFACLI",
            targets: ["EFACLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/LambdaDigamma/ModernNetworking.git", from: "0.1.2"),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.14.0"),
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "1.2.8")),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "EFAAPI",
            dependencies: ["XMLCoder", "ModernNetworking", "Factory", "Core"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "EFAUI",
            dependencies: ["EFAAPI", "Factory", "Core"]
        ),
        .executableTarget(
            name: "EFACLI",
            dependencies: ["EFAAPI", "Factory"]
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
