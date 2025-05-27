//
//  AppVersionCheckImpl.swift
//  Domain
//
//  Created by 조호근 on 5/21/25.
//

import Foundation
import RxSwift

public final class AppVersionCheckImpl: AppVersionCheckUseCase {
    
    let appID = "6741756312"
    
    public init() {}
    
    public func checkAppVersion() -> Observable<AppVersionStatus> {
        return Observable.create { observer in
            guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                  let url = URL(string: "https://itunes.apple.com/lookup?id=\(self.appID)") else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let results = json["results"] as? [[String: Any]],
                      let appStoreVersion = results.first?["version"] as? String else {
                    observer.onCompleted()
                    return
                }
                
                if appStoreVersion > currentVersion {
                    observer.onNext(.updateAvailable(currentVersion: currentVersion, latestVersion: appStoreVersion))
                } else {
                    observer.onNext(.latest)
                }
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
