//
//  MainViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//

import Foundation
import SwiftUI
import Firebase
import GoogleMobileAds

class MainViewModel: ObservableObject {
    @ObservedObject var keyboardViewModel: KeyboardViewModel = KeyboardViewModel()
    var game: Game = Game()
    var currentRow: Int = 0
    var currentColumn: Int = 0
    @Published var rows: [[Key]] = makeAnswerBoardRows()
    @Published var isGameFinished: Bool = false
    @Published var isWordValid: Bool = true
    let rewardADViewController = RewardedADViewController()
    
    init () {
        game.wordDict = WordDictManager.makeWordDict()
        game.answer = todayAnswer()
        UserDefaults.standard.set(game.answer, forKey: "Answer")
        print(game.answer)
        game.key = []
        game.userAnswer = Answer(keys: [[]])
        rewardADViewController.loadAD()
    }
    // MARK: Public Functions
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
            
            // Event Logs
            
            Analytics.logEvent("PlayerSubmit", parameters: [
                AnalyticsParameterItemID: currentWord,
            ])
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
        for (idx, key) in rows[currentRow].enumerated() {
            if game.answer.getChar(at: idx) == key.character.first {
                rows[currentRow][idx].status = .green
                keyboardViewModel.changeKeyStatus(to: .green, keyLabel: key.character)
                jamoCount[key.character.first!]! -= 1
            }
        }
        for (idx, key) in rows[currentRow].enumerated() {
            if game.answer.contains(key.character) && rows[currentRow][idx].status != .green && jamoCount[key.character.first!]! != 0 {
                rows[currentRow][idx].status = .yellow
                keyboardViewModel.changeKeyStatus(to: .yellow, keyLabel: key.character)
            }
        }
        for (idx, key) in rows[currentRow].enumerated() {
            if rows[currentRow][idx].status != .green && rows[currentRow][idx].status != .yellow {
                rows[currentRow][idx].status = .gray
                keyboardViewModel.changeKeyStatus(to: .gray, keyLabel: key.character)
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
        Analytics.logEvent("PlayerWin", parameters: [
            AnalyticsParameterItemID: game.answer,
            AnalyticsParameterLevel: currentRow
        ])
        userLog("win")
        
    }
    fileprivate func playerLose() {
        self.isGameFinished = true
        print("You lose :(")
        Analytics.logEvent("PlayerLose", parameters: [
            AnalyticsParameterItemID: game.answer
        ])
        userLog("lose")
    }
    
    private func userLog(_ state: String) {
        let username = UIDevice.current.name
        let deivceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        Analytics.logEvent(state + "-" + username + "-" + deivceUUID, parameters: nil)
    }
    
    fileprivate func isinDict(of input: String) -> Bool {
        for word in game.wordDict where word.jamo == input {
            return true
        }
        return false
    }
    private static func makeAnswerBoardRows() -> [[Key]] {
        return Array(
            repeating: Range(0...4).map { _ in
                Key(character: " ", status: .white)
            }, count: 6)
    }
    
    func generateString() -> String {
        var ret: String = ""
        for row in rows {
            for char in row {
                switch char.status {
                case .gray :
                    ret += "⬜️"
                case .green :
                    ret += "🟩"
                case .yellow :
                    ret += "🟧"
                case .white, .red, .lightGray, .black:
                    break
                }
            }
            ret += "\n"
        }
        return "한들\n앱주소: https://apps.apple.com/us/app/한들/id1619947572\n" + ret.trimmingCharacters(in: .newlines)
    }
    
    func startNewGame() {
        rewardADViewController.doSomething() { [self] _ in
            if rewardADViewController.didRewardUser(with: GADAdReward()) {
                game.wordDict = WordDictManager.makeWordDict()
                let randomAnswer = game.wordDict[Int.random(in: 0...game.wordDict.count) % game.wordDict.count].jamo
                game.answer = randomAnswer
                print(game.answer)
                initGame()
            }
            rewardADViewController.loadAD()
        }
    }
    
    func refreshGameOnActive() {
        game.wordDict = WordDictManager.makeWordDict()
        let todayAnswer = todayAnswer()
        if UserDefaults.standard.string(forKey: "Answer") != todayAnswer {
            game.answer = todayAnswer
            UserDefaults.standard.set(game.answer, forKey: "Answer")
            print(game.answer)
            initGame()
        }
    }
    
    func todayAnswer() -> String {
        let date = Date()
        let today = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        let todayAnswer = game.wordDict[((today.year! + today.month! + today.day!) * 345678) % game.wordDict.count].jamo
        return todayAnswer
    }
    
    func initGame() {
        game.key = []
        game.userAnswer = Answer(keys: [[]])
        rows = MainViewModel.makeAnswerBoardRows()
        keyboardViewModel.initKeyStatus()
        currentRow = 0
        currentColumn = 0
        isGameFinished = false
    }
    
}
