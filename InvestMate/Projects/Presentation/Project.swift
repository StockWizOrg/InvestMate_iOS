//
//  Project.swift
//  InvestMateManifests
//
//  Created by 조호근 on 10/1/24.
//

import ProjectDescription

let project = Project(
    name: "Presentation",
    options: .options(
        defaultKnownRegions: ["en", "ko", "ja"],
        developmentRegion: "en"
    ),
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Presentation",
            deploymentTargets: .iOS("17.5"),
            sources: "Sources/**",
            resources: [
                "Resources/**"
            ],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "ReactorKit")
            ],
            settings: .settings(
                base: [
                    "SWIFT_EMIT_LOC_STRINGS": "YES"
                ]
            )
        )
    ]
)
