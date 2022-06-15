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
                    HapticsManager.shared.playSound(id: 1322) //
                    Analytics.logEvent("PlayerWin", parameters: [
                        AnalyticsParameterItemID: game.answer,
                        AnalyticsParameterLevel: game.currentRow
                    ])
                    userLog("win")
                } else if !game.didPlayerWin {
                    print("You lose :(")
                    HapticsManager.shared.notification(type: .error)
                    HapticsManager.shared.playSound(id: 1006)
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
    
    public func refreshGameOnActive() -> Bool {
        let today = getTodayDateString()
        let lastDate = UserDefaults.standard.string(forKey: "lastDate")
        if today != lastDate {
            UserDefaults.standard.set(today, forKey: "lastDate")
            UserDefaults.standard.set(1, forKey: "todayGameCount")
            game = Game(answer: todayAnswer())
            print("TodayGameAnwer: " + game.answer)
            return true
        }
        return false
    }
    
    func generateIntToNthString(_ nth: Int) -> String {
        let intToStringDict = ["한", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉"]
        let int10ToStringDict = ["열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
        let int100ToStringDict = ["백", "이백", "삼백", "사백", "오백", "육백", "칠백", "팔백", "구백"]
        var ret = ""
        
        if nth == 1 {
            return "첫 번째 #한들"
        } else if nth == 20 {
            return "스무 번째 #한들"
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
        return ret + " 번째 #한들"
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
        let lastDate = UserDefaults.standard.string(forKey: "lastDate") ?? "00-00"
        let todayMonth = generateIntToString(Int(lastDate.components(separatedBy: "-")[1])!) + "월 "
        let todayDay = generateIntToString(Int(lastDate.components(separatedBy: "-")[2])!) + "일"
        
        return todayMonth + todayDay
    }
    
    func generateString() -> String {
        let streakCount = Statistics().currentWinStreak
        var ret: String = ""
        let date: String = generateDateToString() // 오늘의 날짜(일월 이십일일)
        var title: String = generateIntToNthString(game.gameNumber) // 첫번째 한들 (1/6)
        let streak: String = streakCount != 0 ? "[ \(streakCount)연승중👍 ]" : "[ 연승끝........ ]"
        let appAddress: String = "apple.co/3LPwwAQ"
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
        return "\(date)\n\(title)\n\(streak)\n\(appAddress)\n" + ret.trimmingCharacters(in: .newlines)
    }
    
    func refreshViewForCWmode() {
        self.objectWillChange.send()
    }
    
    func startNewGame() {
        guard refreshGameOnActive() == false else { return }
        rewardADViewController.doSomething() { [self] _ in
            if rewardADViewController.didRewardUser(with: GADAdReward()) {
                let randomAnswer = randomAnswerGenerator()
                let newGame = Game(answer: randomAnswer)
                self.game = newGame
                self.game.saveCurrentGame()
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
    generator = RandomNumberGeneratorWithSeed(seed: DateToSeed())
    let wordDictCount = WordDictManager.shared.wordDictFiveJamo.count
    let randomAnswer = WordDictManager.shared.wordDictFiveJamo[Int(generator.next()) % wordDictCount].jamo
    var answers: [String] = []
    answers.append(randomAnswer)
    UserDefaults.standard.set(answers, forKey: "todayAnswers")
    return randomAnswer
}

func randomAnswerGenerator() -> String {
    let wordDictCount = WordDictManager.shared.wordDictFiveJamo.count
    var randomNumber = Int(generator.next())
    var randomAnswer = WordDictManager.shared.wordDictFiveJamo[randomNumber % wordDictCount].jamo
    var answers = UserDefaults.standard.stringArray(forKey: "todayAnswers") ?? []
    var i = 0
    while answers.contains(randomAnswer) {
        randomNumber = Int(generator.next())
        randomAnswer = WordDictManager.shared.wordDictFiveJamo[(randomNumber) % wordDictCount].jamo
        i += 1
        if i > 1000 {
            break
        }
    }
    answers.append(randomAnswer)
    print("Answer: " + randomAnswer)
    UserDefaults.standard.set(answers, forKey: "todayAnswers")
    return randomAnswer
}

func DateToSeed() -> Int {
    let date = Date()
    let today = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
    let todaySeed = today.year! * 10000 + today.month! * 100 + today.day!
    return todaySeed
}
