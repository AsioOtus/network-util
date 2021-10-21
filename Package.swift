// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BaseNetworkUtil",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
    products: [
        .library(
            name: "BaseNetworkUtil",
            targets: ["BaseNetworkUtil"]),
    ],
    targets: [
        .target(
            name: "BaseNetworkUtil"
		),
        .testTarget(
            name: "BaseNetworkUtilTests",
            dependencies: ["BaseNetworkUtil"]
		),
    ]
)
