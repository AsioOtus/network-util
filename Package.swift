// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NetworkingUtil",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
    products: [
        .library(
            name: "NetworkingUtil",
            targets: ["NetworkingUtil"]),
    ],
    targets: [
        .target(
            name: "NetworkingUtil"
		),
        .testTarget(
            name: "NetworkingUtilTests",
            dependencies: ["NetworkingUtil"]
		),
    ]
)
