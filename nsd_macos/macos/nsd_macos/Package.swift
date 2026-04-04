// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "nsd_macos",
    platforms: [
        .macOS("10.15"),
    ],
    products: [
        .library(name: "nsd-macos", targets: ["nsd_macos"]),
    ],
    targets: [
        .target(
            name: "nsd_macos",
            path: "Sources/nsd_macos"
        ),
    ]
)
