// swift-tools-version:5.7

import PackageDescription

let package = Package(
	name: "network-util",
	platforms: [
		.iOS(.v13),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "NetworkUtil",
			targets: ["NetworkUtil"]
		),
        .library(
            name: "NetworkUtilTestSupport",
            targets: ["NetworkUtilTestSupport"]
        ),
	],
	targets: [
		.target(
			name: "NetworkUtil"
		),
        .target(
            name: "NetworkUtilTestSupport",
            dependencies: ["NetworkUtil"]
        ),
		.executableTarget(
			name: "Testground",
			dependencies: ["NetworkUtil"]
		),
		.testTarget(
			name: "NetworkUtilTests",
			dependencies: [
                "NetworkUtil",
                "NetworkUtilTestSupport"
            ]
		),
	]
)
