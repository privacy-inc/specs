// swift-tools-version:5.5
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
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main")),
        .package(name: "Domains", url: "https://github.com/privacy-inc/domains.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "Specs",
            dependencies: ["Archivable", "Domains"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Specs"],
            path: "Tests"),
    ]
)
