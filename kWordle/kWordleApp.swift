//
//  kWordleApp.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI

@main
struct KWordleApp: App {
//    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
//        .onChange(of: scenePhase) { newScenePhase in
//            switch newScenePhase {
//            case .active:
//                print("App is active")
//            case .inactive:
//                print("App is inactive")
//            case .background:
//                print("App is in background")
//            @unknown default:
//                print("Oh - interesting: I received an unexpected new value.") }
//        }
    }
}
