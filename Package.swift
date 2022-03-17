// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Specs",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Specs",
            targets: ["Specs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main"),
        .package(url: "https://github.com/privacy-inc/domains.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Specs",
            dependencies: [
                .product(name: "Archivable", package: "package"),
                .product(name: "Domains", package: "domains")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Specs"],
            path: "Tests"),
    ]
)
