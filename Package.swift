// swift-tools-version:5.7

import PackageDescription

let package = Package(
	name: "NetworkUtil",
	platforms: [
		.iOS(.v13),
		.macOS(.v13)
	],
	products: [
		.library(
			name: "NetworkUtil",
			targets: ["NetworkUtil"]),
	],
	targets: [
		.target(name: "NetworkUtil"),
		.testTarget(
			name: "NetworkUtilTests",
			dependencies: ["NetworkUtil"]
		),
	]
)
