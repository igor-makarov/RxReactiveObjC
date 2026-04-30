// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxReactiveObjC",
    products: [
        .library(name: "RxReactiveObjC", targets: ["RxReactiveObjC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", "5.0.0"..<"7.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", "4.0.0"..<"6.0.0"),
        .package(name: "ReactiveObjC",
                 url: "https://github.com/SwiftPM-Packages/ReactiveObjC.swiftpm",
                 from: "3.1.0"),
    ],
    targets: [
        .target(name: "RxReactiveObjC",
                dependencies: [
                    "ReactiveObjC",
                    "RxSwift",
                    .product(name: "RxCocoa", package: "RxSwift"),
                    "RxDataSources",
                ],
                path: "Sources"),
        .testTarget(name: "Tests",
                    dependencies: ["ReactiveObjC", "RxSwift", "RxReactiveObjC"],
                    path: "Tests"),
    ]
)
