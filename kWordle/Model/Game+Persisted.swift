//
//  Game+Persisted.swift
//  한들
//
//  Created by JaemooJung on 2022/04/26.
//

import Foundation
import RealmSwift

class PersistedGame: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var timestamp = Date()
    @Persisted var jamoCount = 5
    @Persisted var gameNumber = 1
    @Persisted var answer: String = ""
    @Persisted var keyBoard: Data = Data()
    @Persisted var answerBoard: Data = Data()
    @Persisted var isGameFinished: Bool = false
    @Persisted var didPlayerWin: Bool = false
    @Persisted var didPlayerLose: Bool = false
    @Persisted var currentRow: Int = 0
    @Persisted var currentColumn: Int = 0
}
