//
//  kWordleApp.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI
import CoreData

@main
struct KWordleApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .onAppear {
//                    //여기서 앱 실행시에 DB에 아무것도 없으면 파일에서 불러와 DB초기화
//                    if UserDefaults.standard.bool(forKey: "isDBinited") == false {
//                        WordDictManager.initWordDB()
//                    }
//                }
        }
    }
}
