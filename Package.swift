// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "MicroChat-Server",
	products: [
		.executable(name: "MicroChat-Server", targets: ["MicroChat-Server"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0"),
	],
	targets: [
        .target(name: "MicroChat-Server", dependencies: ["PerfectHTTPServer", "PerfectMySQL"])
	]
)
