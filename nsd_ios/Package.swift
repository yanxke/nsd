// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "nsd_ios",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "nsd_ios", targets: ["nsd_ios"]),
    ],
    targets: [
        .target(
            name: "nsd_ios",
            path: "ios/Classes"
        ),
    ]
)
