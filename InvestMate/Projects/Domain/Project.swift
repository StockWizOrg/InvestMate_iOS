//
//  Project.swift
//  Config
//
//  Created by 조호근 on 10/1/24.
//

import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Domain",
            deploymentTargets: .iOS("17.5"),
            sources: "Sources/**",
            dependencies: [
                .external(name: "RxSwift")
            ]
        ),
        
        .target(
            name: "StockTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.StockTests",
            deploymentTargets: .iOS("17.5"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        )
    ]
)
