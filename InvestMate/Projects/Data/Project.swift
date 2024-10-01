//
//  Data.swift
//  Config
//
//  Created by 조호근 on 10/1/24.
//

import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "io.tuist.Data",
            deploymentTargets: .iOS("17.5"),
            sources: "Sources/**",
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        )
    ]
)
