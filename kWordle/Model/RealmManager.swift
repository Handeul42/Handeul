//
//  RealmManager.swift
//  한들
//
//  Created by JaemooJung on 2022/04/26.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared: RealmManager = RealmManager()
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    public func getPreviousGame() -> PersistedGame? {
        let previousGame = realm.objects(PersistedGame.self).sorted(byKeyPath: "timestamp", ascending: false).first
        return previousGame
    }
    
    public func saveGame(_ game: PersistedGame) {
        try? realm.write {
            realm.add(game, update: .modified)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
