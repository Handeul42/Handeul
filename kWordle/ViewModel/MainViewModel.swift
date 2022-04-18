//
//  MainViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//

import Foundation

class MainViewModel: ObservableObject {
    var keyboardViewModel: KeyboardViewModel = KeyboardViewModel()
    var game: Game = Game()
    var currentRow: Int = 0
    var currentColumn: Int = 0
    @Published var rows: [[Key]] = Array(
        repeating: Range(0...4).map { _ in Key(character: " ")},
        count: 6)
    var currentWord: String = ""
    
    init () {
        game.wordDict = WordDictManager.makeWordDict()
        game.answer = game.wordDict[0].jamo
        game.key = []
        game.userAnswer = Answer(keys: [[]])
    }
    
    func appendReceivedCharacter(of receivedKeyCharacter: String) {
        if currentColumn <= 5 {
            rows[currentRow][currentColumn].character = receivedKeyCharacter
            currentWord += receivedKeyCharacter
            currentColumn += 1
        }
    }
    
    func deleteOneCharacter() {
        if currentColumn != 0 {
            currentColumn -= 1
            _ = currentWord.popLast()
            rows[currentRow][currentColumn].character = ""
        }
    }
    
    func submitAnswer() {
        let currentWord: String = rows[currentRow].map({ $0.character }).joined(separator: "")
        print(game.answer)
        
        if currentColumn == 5 && currentRow != 6 {
            /*
             TODO: 제출하는 함수
             */
            
            if !isinDict(of: currentWord) {
                return
            }
            
            if game.answer == currentWord {
                //end game
            } else {
                for (index, key) in rows[currentRow].enumerated() {
                    if game.answer.contains(key.character) {
                        if (game.answer.map { String($0) })[index] == key.character {
                            // green
                            print("green")
                        } else {
                            // yellow
                            print("green")
                        }
                    } else {
                        // gray
                        print("gray")
                    }
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
