//
//  MainViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @ObservedObject var keyboardViewModel: KeyboardViewModel = KeyboardViewModel()
    var game: Game = Game()
    var currentRow: Int = 0
    var currentColumn: Int = 0
    @Published var rows: [[Key]] = makeAnswerBoardRows()
    @Published var isGameFinished: Bool = false
    @Published var isWordValid: Bool = true
    init () {
        let date = Date()
        let today = Calendar.current.dateComponents([.day, .hour], from: date)
        game.wordDict = WordDictManager.makeWordDict()
        game.answer = game.wordDict[(today.day! + today.hour! * 130) % game.wordDict.count].jamo
        print(game.answer)
        game.key = []
        game.userAnswer = Answer(keys: [[]])
    }
    //MARK: Public Functions
    public func appendReceivedCharacter(of receivedKeyCharacter: String) {
        guard isGameFinished == false else { return }
        if currentColumn <= 4 {
            rows[currentRow][currentColumn].character = receivedKeyCharacter
            currentColumn += 1
        }
    }
    public func deleteOneCharacter() {
        guard isGameFinished == false else { return }
        if currentColumn != 0 {
            currentColumn -= 1
            rows[currentRow][currentColumn].character = ""
        }
    }
    public func submitAnswer() {
        guard isGameFinished == false else { return }
        let currentWord: String = rows[currentRow].map({ $0.character }).joined(separator: "")
        if currentColumn == 5 && currentRow != 6 {
            if !isinDict(of: currentWord) {
                toggleValidWordState()
                return
            }
            if game.answer == currentWord {
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
    public func toggleValidWordState() {
        self.isWordValid.toggle()
    }
    // MARK: Private Functions
    fileprivate func compareUserAnswerAndChangeColor() {
        var jamoCount = [Character: Int]()
        for jamo in game.answer {
            if jamoCount[jamo] != nil {
                jamoCount[jamo]! += 1
            } else {
                jamoCount[jamo] = 1
            }
        }
        for (index, key) in rows[currentRow].enumerated() {
            if game.answer.contains(key.character) && jamoCount[key.character.first!] != 0 {
                if (game.answer.map { String($0) })[index] == key.character {
                    keyboardViewModel.changeKeyStatus(to: .green, keyLabel: key.character)
                    rows[currentRow][index].status = .green
                } else {
                    keyboardViewModel.changeKeyStatus(to: .yellow, keyLabel: key.character)
                    rows[currentRow][index].status = .yellow
                }
                jamoCount[key.character.first!]! -= 1
            } else {
                keyboardViewModel.changeKeyStatus(to: .gray, keyLabel: key.character)
                rows[currentRow][index].status = .gray
            }
        }
    }
    fileprivate func playerWin() {
        for (index, key) in rows[currentRow].enumerated() {
            rows[currentRow][index].status = .green
            keyboardViewModel.changeKeyStatus(to: .green, keyLabel: key.character)
        }
        self.isGameFinished = true
        print("Cool! You win!")
    }
    fileprivate func playerLose() {
        self.isGameFinished = true
        print("You lose :(")
    }
    fileprivate func isinDict(of input: String) -> Bool {
        for word in game.wordDict where word.jamo == input {
            return true
        }
        return false
    }
    fileprivate static func makeAnswerBoardRows() -> [[Key]] {
        Array(
            repeating: Range(0...4).map { _ in
                Key(character: " ", status: .white)
            }, count: 6)
    }
}
