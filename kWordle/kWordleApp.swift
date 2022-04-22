//
//  kWordleApp.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI
import Firebase

@main
struct KWordleApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    print(uiSize)
                }
        }
    }
}
