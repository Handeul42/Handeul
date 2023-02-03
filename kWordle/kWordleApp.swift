//
//  kWordleApp.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import UserNotifications

@main
struct KWordleApp: App {
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UNUserNotificationCenter.current().delegate = .none
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
