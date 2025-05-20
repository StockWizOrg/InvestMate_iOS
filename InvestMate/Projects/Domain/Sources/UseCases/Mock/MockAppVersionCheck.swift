//
//  MockAppVersionCheck.swift
//  Domain
//
//  Created by 조호근 on 5/21/25.
//

import Foundation
import RxSwift

public final class MockAppVersionCheck: AppVersionCheckUseCase {
    
    private let shouldShowUpdate: Bool
    
    public init(shouldShowUpdate: Bool = false) {
        self.shouldShowUpdate = shouldShowUpdate
    }
    
    public func checkAppVersion() -> Observable<AppVersionStatus> {
        if shouldShowUpdate {
            return .just(.updateAvailable(currentVersion: "1.0.1", latestVersion: "1.0.2"))
        } else {
            return .just(.latest)
        }
    }
}
