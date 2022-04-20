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
    @Published var rows: [[Key]] = Array(
        repeating: Range(0...4).map { _ in Key(character: " ", status: .white)},
        count: 6)
    @Published var isGameFinished: Bool = false
    init () {
        game.wordDict = WordDictManager.makeWordDict()
        game.answer = game.wordDict[0].jamo
        game.key = []
        game.userAnswer = Answer(keys: [[]])
    }
    func appendReceivedCharacter(of receivedKeyCharacter: String) {
        guard isGameFinished == false else { return }
        if currentColumn <= 4 {
            rows[currentRow][currentColumn].character = receivedKeyCharacter
            currentColumn += 1
        }
    }
    func deleteOneCharacter() {
        guard isGameFinished == false else { return }
        if currentColumn != 0 {
            currentColumn -= 1
            rows[currentRow][currentColumn].character = ""
        }
    }
    func submitAnswer() {
        guard isGameFinished == false else { return }
        let currentWord: String = rows[currentRow].map({ $0.character }).joined(separator: "")
        if currentColumn == 5 && currentRow != 6 {
            if !isinDict(of: currentWord) {
                print("Cannot find the word from dictionary")
                return
            }
            if game.answer == currentWord {
                for (index, key) in rows[currentRow].enumerated() {
                    rows[currentRow][index].status = .green
                    keyboardViewModel.changeKeyStatus(to: .green, keyLabel: key.character)
                }
                self.isGameFinished = true
                print("Cool! Game is finished!")
            } else {
                for (index, key) in rows[currentRow].enumerated() {
                    if game.answer.contains(key.character) {
                        if (game.answer.map { String($0) })[index] == key.character {
                            keyboardViewModel.changeKeyStatus(to: .green, keyLabel: key.character)
                            rows[currentRow][index].status = .green
                        } else {
                            keyboardViewModel.changeKeyStatus(to: .yellow, keyLabel: key.character)
                            rows[currentRow][index].status = .yellow
                        }
                    } else {
                        keyboardViewModel.changeKeyStatus(to: .gray, keyLabel: key.character)
                        rows[currentRow][index].status = .gray
                    }
                }
                if currentRow == 5 {
                    print("You lose :(")
                    self.isGameFinished = true
                }
            }
            currentRow += 1
            currentColumn = 0
        }
    }
    func isinDict(of input: String) -> Bool {
        for word in game.wordDict where word.jamo == input {
            return true
        }
        return false
    }
}
