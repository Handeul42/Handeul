//
//  VersionCheck.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/17.
//

import Foundation
import UIKit

func checkUpdate(completion: @escaping (Bool) -> Void) {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    latestVersion { latestVersion in
        guard let latestVersion = latestVersion else { completion(false); return }
        if let lastCheckVersion = UserDefaults.standard.string(forKey: "latestVersion") {
            let compareVersion = lastCheckVersion.compare(latestVersion, options: .numeric)
            if compareVersion != .orderedAscending {
                completion(false); return
            }
        }
        UserDefaults.standard.set(latestVersion, forKey: "latestVersion")
        
        let compareResult = appVersion?.compare(latestVersion, options: .numeric)
        
        if compareResult == .orderedAscending {
            completion(true)
        } else {
            completion(false)
        }
    }
}

func latestVersion(completion: @escaping (String?) -> Void) {
    let appleID = "1619947572"
    guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)") else {
        completion(nil); return
    }
    let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            completion(nil); return
        }
        completion(appStoreVersion)
    }
    task.resume()
}

func openAppStore() {
    let appleID = "1619947572"
    let appStoreOpneUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
    guard let url = URL(string: appStoreOpneUrlString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
