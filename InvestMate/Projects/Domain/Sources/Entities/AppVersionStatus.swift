//
//  AppVersionStatus.swift
//  Domain
//
//  Created by 조호근 on 5/21/25.
//

import Foundation

public enum AppVersionStatus {
    case latest
    case updateAvailable(currentVersion: String, latestVersion: String)
}
