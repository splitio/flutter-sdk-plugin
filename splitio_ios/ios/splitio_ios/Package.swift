// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "splitio_ios",
  platforms: [
    .iOS("12.0")
  ],
  products: [
    .library(name: "splitio-ios", targets: ["splitio_ios"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(url: "https://github.com/splitio/ios-client", "3.6.0" ..< "3.7.0")
  ],
  targets: [
    .target(
      name: "splitio_ios",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(name: "Split", package: "ios-client")
      ]
    )
  ]
)
