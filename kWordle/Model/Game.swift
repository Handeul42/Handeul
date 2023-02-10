//
//  Game.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation
import Firebase

struct Game {
    
    private var id: String = UUID().uuidString
    private var timestamp = Date()
    private var jamoCount = 5
    private(set) var gameNumber: Int
    private(set) var answer: String
    private(set) var wordDict: [WordDict]
    private(set) var keyBoard: KeyBoard
    private(set) var answerBoard: [[Key]]
    private(set) var isGameFinished: Bool = false
    private(set) var didPlayerWin: Bool = false
    private(set) var currentRow: Int = 0
    private(set) var currentColumn: Int = 0
    
    init(answer: String) {
        self.answer = answer
        self.wordDict = WordDictManager.shared.wordDictFiveJamo
        keyBoard = Self.initKeyBoard()
        answerBoard = Self.initAnswerBoard()
        self.gameNumber = UserDefaults.standard.integer(forKey: "todayGameCount")
        UserDefaults.standard.set(gameNumber + 1, forKey: "todayGameCount")
    }
}

extension Game {
    
    public func saveCurrentGame() {
        RealmManager.shared.saveGame(self.persistedObject())
    }
    
    public func getCurrentWord() -> String {
        return answerBoard[currentRow].map({ $0.character }).joined(separator: "")
    }
    
    public func isCurrentWordInDict() -> Bool {
        let currentWord = getCurrentWord()
        for word in wordDict where word.jamo == currentWord {
            return true
        }
        return false
    }
    
    mutating func appendReceivedCharacter(of receivedChar: String) {
        guard isGameFinished == false else { return }
        if currentColumn <= 4 {
            answerBoard[currentRow][currentColumn].changeCharacter(to: receivedChar)
            currentColumn += 1
        }
    }
    
    mutating func deleteOneCharacter() {
        guard isGameFinished == false else { return }
        if currentColumn != 0 {
            currentColumn -= 1
            answerBoard[currentRow][currentColumn].changeCharacter(to: "")
        }
    }
    
    mutating func submitAnswer() {
        guard isGameFinished == false else { return }
        let currentWord: String = answerBoard[currentRow].map({ $0.character }).joined(separator: "")
        
        if currentColumn == 5 && currentRow != 6 {
            Analytics.logEvent("PlayerSubmit", parameters: [
                AnalyticsParameterItemID: currentWord,
                AnalyticsParameterLevel: currentRow
            ])
            if self.answer == currentWord {
                playerWin()
                return
            } else {
                compareUserAnswerAndChangeColor()
                if currentRow == 5 {
                    playerLose()
                    return
                }
            }
            currentRow += 1
            currentColumn = 0
        }
    }
        
    mutating func compareUserAnswerAndChangeColor() {
        var jamoCount = [Character: Int]()
        for jamo in answer {
            if jamoCount[jamo] != nil {
                jamoCount[jamo]! += 1
            } else {
                jamoCount[jamo] = 1
            }
        }
        for (idx, key) in answerBoard[currentRow].enumerated() {
            if answer.getChar(at: idx) == key.character.first {
                answerBoard[currentRow][idx].changeStatus(to: .green)
                keyBoard.changeKeyStatus(to: .green, keyLabel: key.character)
                jamoCount[key.character.first!]! -= 1
            }
        }
        for (idx, key) in answerBoard[currentRow].enumerated() {
            if answer.contains(key.character) && answerBoard[currentRow][idx].status != .green && jamoCount[key.character.first!]! != 0 {
                self.answerBoard[currentRow][idx].changeStatus(to: .yellow)
                keyBoard.changeKeyStatus(to: .yellow, keyLabel: key.character)
            }
        }
        for (idx, key) in answerBoard[currentRow].enumerated() {
            if answerBoard[currentRow][idx].status != .green && answerBoard[currentRow][idx].status != .yellow {
                answerBoard[currentRow][idx].changeStatus(to: .gray)
                keyBoard.changeKeyStatus(to: .gray, keyLabel: key.character)
            }
        }
    }
    
    mutating func playerWin() {
        for (index, key) in answerBoard[currentRow].enumerated() {
            answerBoard[currentRow][index].changeStatus(to: .green)
            keyBoard.changeKeyStatus(to: .green, keyLabel: key.character)
        }
        isGameFinished = true
        didPlayerWin = true
        saveCurrentGame()
    }
    
    mutating func playerLose() {
        isGameFinished = true
        saveCurrentGame()
    }
    
    static func initKeyBoard() -> KeyBoard {
        let firstRowLabel = ["ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅛ", "ㅕ", "ㅑ"]
        let secondRowLabel = ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅗ", "ㅓ", "ㅏ", "ㅣ"]
        let thirdRowLabel = ["ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ"]
        
        let newKeyBoard = KeyBoard(firstRow: firstRowLabel.map { Key(character: $0) },
                                   secondRow: secondRowLabel.map { Key(character: $0) },
                                   thirdRow: thirdRowLabel.map { Key(character: $0) })
        return newKeyBoard
    }
    
    static func initAnswerBoard() -> [[Key]] {
        return Array(
            repeating: Range(0...4).map { _ in Key(character: " ", status: .white)},
            count: 6)
    }
}

extension Game: Persistable {
    
    typealias PersistedObject = PersistedGame
    
    init(persistedObject: PersistedGame) {
        
        let decoder = JSONDecoder()
        
        self.id = persistedObject.id
        self.timestamp = persistedObject.timestamp
        self.gameNumber = persistedObject.gameNumber
        self.jamoCount = persistedObject.jamoCount
        self.answer = persistedObject.answer
        self.answerBoard = try! decoder.decode([[Key]].self, from: persistedObject.answerBoard)
        self.keyBoard = try! decoder.decode(KeyBoard.self, from: persistedObject.keyBoard)
        self.didPlayerWin = persistedObject.didPlayerWin
        self.isGameFinished = persistedObject.isGameFinished
        self.currentRow = persistedObject.currentRow
        self.currentColumn = persistedObject.currentColumn
        self.wordDict = WordDictManager.shared.wordDictFiveJamo

    }
    
    func persistedObject() -> PersistedGame {
        let encoder = JSONEncoder()
        let persistedGame = PersistedGame()
        
        persistedGame.id = self.id
        persistedGame.timestamp = self.timestamp
        persistedGame.jamoCount = self.jamoCount
        persistedGame.gameNumber = self.gameNumber
        persistedGame.answer = self.answer
        persistedGame.keyBoard = try! encoder.encode(self.keyBoard)
        persistedGame.answerBoard = try! encoder.encode(self.answerBoard)
        persistedGame.isGameFinished = self.isGameFinished
        persistedGame.didPlayerWin = self.didPlayerWin
        persistedGame.currentRow = self.currentRow
        persistedGame.currentColumn = self.currentColumn
        
        return persistedGame
    }
}
