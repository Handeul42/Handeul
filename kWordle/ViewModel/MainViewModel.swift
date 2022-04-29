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

var generator = RandomNumberGeneratorWithSeed(seed: DateToSeed())
class MainViewModel: ObservableObject {
    @Published var game: Game
    @Published var isInvalidWordWarningPresented: Bool = false
    let rewardADViewController = RewardedADViewController()
    
    init () {
        let today = getTodayDateString()
        let lastDate = UserDefaults.standard.string(forKey: "lastDate")
        if today != lastDate {
            UserDefaults.standard.set(today, forKey: "lastDate")
            UserDefaults.standard.set(1, forKey: "todayGameCount")
            UserDefaults.standard.set([], forKey: "todayAnswers")
            game = Game(answer: todayAnswer())
            print(game.answer)
            return
        }
        if let previousGame = RealmManager.shared.getPreviousGame() {
            game = Game(persistedObject: previousGame)
        } else {
            game = Game(answer: todayAnswer())
        }
        print(game.answer)
        rewardADViewController.loadAD()
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
                HapticsManager.shared.notification(type: .warning)
                return
            }
            game.submitAnswer()
            if game.isGameFinished {
                if game.didPlayerWin {
                    print("Cool! You win!")
                    HapticsManager.shared.notification(type: .success)
                    Analytics.logEvent("PlayerWin", parameters: [
                        AnalyticsParameterItemID: game.answer,
                        AnalyticsParameterLevel: game.currentRow
                    ])
                    userLog("win")
                } else if !game.didPlayerWin {
                    print("You lose :(")
                    HapticsManager.shared.notification(type: .error)
                    Analytics.logEvent("PlayerLose", parameters: [
                        AnalyticsParameterItemID: game.answer
                    ])
                    userLog("lose")
                }
            }
        }
    }
    
    public func presentInvalidWordWarning() {
        isInvalidWordWarningPresented = true
    }
    
    public func closeInvalidWordWarning() {
        isInvalidWordWarningPresented = false
    }
    
    func generateIntToNthString(_ nth: Int) -> String {
        let intToStringDict = ["한", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉"]
        let int10ToStringDict = ["열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
        let int100ToStringDict = ["백", "이백", "삼백", "사백", "오백", "육백", "칠백", "팔백", "구백"]
        var ret = ""
        
        if nth == 1 {
            return "첫"
        } else if nth == 20 {
            return "스무"
        } else {
            if nth / 100 != 0 {
                ret += int100ToStringDict[nth / 100 - 1]
            }
            if (nth % 100) / 10 != 0 {
                ret += int10ToStringDict[(nth % 100) / 10 - 1]
            }
            if (nth % 100) % 10 != 0 {
                ret += intToStringDict[(nth % 100) % 10 - 1]
            }
        }
        return ret + " 번째 한들"
    }
    
    func generateIntToString(_ date: Int) -> String {
        let intToStringDict = ["일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let int10ToStringDict = ["십", "이십", "삼십"]
        var ret = ""
        
        if date / 10 != 0 {
            ret += int10ToStringDict[date / 10 - 1]
        }
        if date % 10 != 0 {
            ret += intToStringDict[date % 10 - 1]
        }
        return ret
    }
    
    func generateDateToString() -> String {
        let date = Date()
        let todayMonth = generateIntToString(Calendar.current.dateComponents([.month], from: date).month!) + "월 "
        let todayDay = generateIntToString(Calendar.current.dateComponents([.day], from: date).day!) + "일"
        
        return todayMonth + todayDay
    }
    
    func generateString() -> String {
        var ret: String = ""
        let date: String = generateDateToString() // 오늘의 날짜(일월 이십일일)
        var title: String = generateIntToNthString(game.gameNumber) // 첫번째 한들 (1/6)
        let appAddress: String = "https://apple.co/3rWFLqZ"
        title += game.didPlayerWin ? " (\(game.currentRow + 1)/6)" : " (🤯)"
        for row in game.answerBoard {
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
        return "\(date)\n\(title)\n\(appAddress)\n" + ret.trimmingCharacters(in: .newlines)
    }
    
    func startNewGame() {
        rewardADViewController.doSomething() { [self] _ in
            if rewardADViewController.didRewardUser(with: GADAdReward()) {
                
                for _ in 0...100 {
                    var randomAnswer = WordDictManager.shared.wordDictFiveJamo[Int(generator.next()) % game.wordDict.count].jamo
                    var answers = UserDefaults.standard.stringArray(forKey: "todayAnswers")!
                    while answers.contains(randomAnswer) {
                        randomAnswer = WordDictManager.shared.wordDictFiveJamo[Int(generator.next()) % game.wordDict.count].jamo
                        if answers.count % 140 == 0 {
                            generator = RandomNumberGeneratorWithSeed(seed: Int(generator.next()))
                        }
                        answers.append(randomAnswer)
                    }
                    let newGame = Game(answer: randomAnswer)
                    print("Answer: " + newGame.answer)
                    UserDefaults.standard.set(answers, forKey: "todayAnswers")
                    self.game = newGame
                    
                }
            }
        }
    }
    
    // MARK: Private Functions
    private func userLog(_ state: String) {
        let deivceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        Analytics.logEvent(state + "-" + deivceUUID, parameters: [:])
    }
}

func todayAnswer() -> String {
    let wordDict = WordDictManager.shared.wordDictFiveJamo
    let todayAnswer = wordDict[Int(generator.next()) % wordDict.count].jamo
    return todayAnswer
}

func DateToSeed() -> Int {
    let date = Date()
    let today = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
    return today.year! * 10000 + today.month! * 100 + today.day!
}
