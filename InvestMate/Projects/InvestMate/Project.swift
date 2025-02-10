import ProjectDescription

let project = Project(
    name: "InvestMate",
    targets: [
        .target(
            name: "InvestMate",
            destinations: .iOS,
            product: .app,
            bundleId: "io.hogeunjo.InvestMate",
            deploymentTargets: .iOS("17.5"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "CFBundleIconName": "AppIcon"
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: "../Presentation"),
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data")
            ],
            settings: .settings(
                base: [
                    "TARGETED_DEVICE_FAMILY": "1"
                ]
            )
        ),
        
        .target(
            name: "InvestMateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.InvestMateTests",
            deploymentTargets: .iOS("17.5"),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "InvestMate")]
        )
    ]
)
