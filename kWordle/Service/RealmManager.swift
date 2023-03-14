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
    
    public func getAllGames() -> Results<PersistedGame> {
        let allGame = realm.objects(PersistedGame.self)
        return allGame
    }
    
    public func getFinishedGames() -> Results<PersistedGame> {
        return realm.objects(PersistedGame.self).where { game in game.isGameFinished == true }
    }
    
    public func getGamesGroupedByDay() -> [String: [PersistedGame]] {
        return Dictionary(grouping: getFinishedGames()) { game -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 M월 d일"
            return dateFormatter.string(from: game.timestamp)
        }
    }
    
    public func getPreviousGame() -> PersistedGame? {
        let previousGame = realm.objects(PersistedGame.self).sorted(byKeyPath: "timestamp", ascending: false).first
        return previousGame
    }
    
    public func saveGame(_ game: PersistedGame) {
        try? realm.write {
            realm.add(game, update: .modified)
        }
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
