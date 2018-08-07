// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ScreamEssentials",
    products: [
        .library(
            name: "ScreamEssentials",
            targets: ["ScreamEssentials"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ScreamEssentials",
            dependencies: [],
            path: "Source"),
    ]
)
