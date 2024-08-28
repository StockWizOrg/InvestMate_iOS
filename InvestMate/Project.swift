import ProjectDescription

let project = Project(
    name: "InvestMate",
    targets: [
        .target(
            name: "InvestMate",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.InvestMate.InvestMate",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": ""
                    ]
                ]
            ),
            sources: ["InvestMate/Sources/**"],
            resources: ["InvestMate/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "InvestMateTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.InvestMate.InvestMateTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["InvestMate/Tests/**"],
            resources: [],
            dependencies: [.target(name: "InvestMate")]
        )
    ]
)
