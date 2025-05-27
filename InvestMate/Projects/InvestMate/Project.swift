import ProjectDescription

let project = Project(
    name: "InvestMate",
    targets: [
        .target(
            name: "InvestMate",
            destinations: [.iPhone],
            product: .app,
            bundleId: "io.hogeunjo.InvestMate",
            deploymentTargets: .iOS("17.5"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleAllowMixedLocalizations": true,
                    "CFBundleShortVersionString": "1.0.5",
                    "ITSAppUsesNonExemptEncryption": false,
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
                    "CODE_SIGN_STYLE": "Manual",
                    "DEVELOPMENT_TEAM": "MVHA5LVM49",
                    "VERSIONING_SYSTEM": "apple-generic",
                    "CURRENT_PROJECT_VERSION": "0"
                ],
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: [
                            "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon",
                            "PRODUCT_BUNDLE_IDENTIFIER": "io.hogeunjo.InvestMate.dev",
                            "PROVISIONING_PROFILE_SPECIFIER": "match Development io.hogeunjo.InvestMate.dev",
                            "CODE_SIGN_IDENTITY": "Apple Development: HoGeun Jo (89N845W6M8)"
                        ]
                    ),
                    .release(
                        name: "Release",
                        settings: [
                            "PRODUCT_BUNDLE_IDENTIFIER": "io.hogeunjo.InvestMate",
                            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore io.hogeunjo.InvestMate",
                            "CODE_SIGN_IDENTITY": "Apple Distribution: HoGeun Jo (MVHA5LVM49)"
                        ]
                    )
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
