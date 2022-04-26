//
//  Game.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

struct Game {
    
    private var id: String = UUID().uuidString
    private var timestamp = Date()
    private(set) var answer: String
    private(set) var wordDict: [WordDict]
    private(set) var keyBoard: KeyBoard
    private(set) var answerBoard: [[Key]]
    private(set) var isGameFinished: Bool = false
    private(set) var didPlayerWin: Bool = false
    private(set) var didPlayerLose: Bool = false
    private(set) var currentRow: Int = 0
    private(set) var currentColumn: Int = 0
    
    init(answer: String) {
        self.answer = answer
        self.wordDict = WordDictManager.shared.wordDict_5jamo
        keyBoard = Self.initKeyBoard()
        answerBoard = Self.initAnswerBoard()
    }
    
}

extension Game {
    
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
            if self.answer == currentWord {
                playerWin()
            } else {
                compareUserAnswerAndChangeColor()
                if currentRow == 5 {
                    playerLose()
                }
            }
            currentRow += 1
            currentColumn = 0
        }
    }
    
    public func getCurrentWord() -> String {
        return answerBoard[currentRow].map({ $0.character }).joined(separator: "")
    }
    
    public func isCurrentWordInDict() -> Bool {
        let currentWord = getCurrentWord()
        print(currentWord)
        for word in wordDict where word.jamo == currentWord {
            return true
        }
        return false
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
    }
    
    mutating func playerLose() {
        isGameFinished = true
        didPlayerLose = true
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

