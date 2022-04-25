//
//  kWordleApp.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct KWordleApp: App {
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
