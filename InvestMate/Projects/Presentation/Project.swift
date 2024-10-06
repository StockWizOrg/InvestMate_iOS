//
//  Project.swift
//  InvestMateManifests
//
//  Created by 조호근 on 10/1/24.
//

import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Presentation",
            deploymentTargets: .iOS("17.5"),
            sources: "Sources/**",
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        )
    ]
)
