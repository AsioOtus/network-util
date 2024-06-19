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
	],
	targets: [
		.target(
			name: "NetworkUtil"
		),
		.executableTarget(
			name: "Testground",
			dependencies: ["NetworkUtil"]
		),
		.testTarget(
			name: "NetworkUtilTests",
			dependencies: ["NetworkUtil"]
		),
	]
)
