// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "nsd_ios",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "nsd-ios", targets: ["nsd_ios"]),
    ],
    targets: [
        .target(
            name: "nsd_ios",
            path: "Sources/nsd_ios"
        ),
    ]
)
