// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "ReactorKit": .framework
        ]
    )
#endif

let package = Package(
    name: "InvestMate",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.8.0")),
        .package(url: "https://github.com/ReactorKit/ReactorKit", .upToNextMajor(from: "3.0.0"))
    ]
)
