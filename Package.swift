// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Flynn",
    platforms: [
        .iOS(.v9), .macOS(.v10_12)
    ],
    products: [
        .library(name: "Flynn", targets: ["Flynn"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Flynn",
            dependencies: [ ]
        ),
        .testTarget(
            name: "FlynnTests",
            dependencies: [ "Flynn" ],
            exclude: [ "Resources" ]
        )

    ]
)
