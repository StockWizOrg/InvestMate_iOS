//
//  AppVersionCheckUseCase.swift
//  Domain
//
//  Created by 조호근 on 5/21/25.
//

import Foundation
import RxSwift

public protocol AppVersionCheckUseCase {
    func checkAppVersion() -> Observable<AppVersionStatus>
}
