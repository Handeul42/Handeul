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
    @AppStorage("isNotFirstOpen")
    var isNotFirstOpen: Bool = UserDefaults.standard.bool(forKey: "isNotFirstOpen")
    @State var isNewVersionAlertPresented: Bool = false
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UNUserNotificationCenter.current().delegate = .none
        if !isNotFirstOpen {
            UserDefaults.standard.set(5, forKey: "life")
            isNotFirstOpen = true
        }
        checkUpdate { [self] updateNeeded in
            self.isNewVersionAlertPresented = updateNeeded
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .alert(isPresented: $isNewVersionAlertPresented, content: {NewVersionAlert()})
        }
    }
}
