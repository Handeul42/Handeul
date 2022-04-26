//
//  MainViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//

import Foundation
import SwiftUI
import Firebase

class MainViewModel: ObservableObject {
    @Published var game: Game
    @Published var isInvalidWordWarningPresented: Bool = false
    
    init () {
        if let previousGame = RealmManager.shared.getPreviousGame() {
            game = Game(persistedObject: previousGame)
            
        } else {
            game = Game(answer: todayAnswer())
        }
        UserDefaults.standard.set(game.answer, forKey: "Answer")
        print(game.answer)
    }
    
    // MARK: Public Functions
    
    public func appendReceivedCharacter(of receivedKeyCharacter: String) {
        game.appendReceivedCharacter(of: receivedKeyCharacter)
    }
    
    public func deleteOneCharacter() {
        game.deleteOneCharacter()
    }
    
    public func submitAnswer() {
        guard game.isGameFinished == false else { return }
        if game.currentColumn == 5 && game.currentRow != 6 {
            if game.isCurrentWordInDict() == false {
                presentInvalidWordWarning()
                return
            }
            // Event Logs
            Analytics.logEvent("PlayerSubmit", parameters: [
                AnalyticsParameterItemID: game.getCurrentWord()
            ])
            game.submitAnswer()
            if game.didPlayerWin {
                print("Cool! You win!")
                Analytics.logEvent("PlayerWin", parameters: [
                    AnalyticsParameterItemID: game.answer,
                    AnalyticsParameterLevel: game.currentRow
                ])
                userLog("win")
            } else {
                print("You lose :(")
                Analytics.logEvent("PlayerLose", parameters: [
                    AnalyticsParameterItemID: game.answer
                ])
                userLog("lose")
            }
        }
    }
    
    public func presentInvalidWordWarning() {
        isInvalidWordWarningPresented = true
    }
    
    public func closeInvalidWordWarning() {
        isInvalidWordWarningPresented = false
    }

    // MARK: Private Functions
    private func userLog(_ state: String) {
        let username = UIDevice.current.name
        let deivceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        Analytics.logEvent(state + "-" + username + "-" + deivceUUID, parameters: nil)
    }
    
    func generateString() -> String {
        var ret: String = ""
        for row in game.answerBoard {
            for char in row {
                switch char.status {
                case .gray :
                    ret += "⬜️"
                case .green :
                    ret += "🟩"
                case .yellow :
                    ret += "🟧"
                case .white, .red, .lightGray:
                    break
                }
            }
            ret += "\n"
        }
        return "한들\n앱주소\n" + ret.trimmingCharacters(in: .newlines)
    }
    
    func startNewGame() {
        let randomAnswer = game.wordDict[Int.random(in: 0...game.wordDict.count) % game.wordDict.count].jamo
        let newGame = Game(answer: randomAnswer)
        print(newGame.answer)
        self.game = newGame
    }
    
}

func todayAnswer() -> String {
    let wordDict = WordDictManager.shared.wordDictFiveJamo
    let date = Date()
    let today = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
    let todayAnswer = wordDict[((today.year! + today.month! + today.day!) * 345678) % wordDict.count].jamo
    return todayAnswer
}
