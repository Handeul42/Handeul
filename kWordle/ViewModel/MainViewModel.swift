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
    @Published var game: Game
    @Published var isInvalidWordWarningPresented: Bool = false
    @Published var isADNotLoaded: Bool = false
    @Published var needUpdate: Bool = false
    @Published var needLife: Bool = false
    @Published var lifeCount: Int = 0 {
        didSet {
            saveLife(lifeCount: lifeCount)
        }
    }
    @Published var isResultAnimationPlaying: Bool = false
    
    @AppStorage("life") var life = UserDefaults.standard.integer(forKey: "life")
    @AppStorage("lifeTimeStamp") var lifeTimeStamp: String = UserDefaults.standard.string(forKey: "lifeTimeStamp") ?? ""
    let rewardADViewController = RewardedADViewController()
    var preventTapShowAdButton: Bool = false
    
    init() {
        if let previousGame = RealmManager.shared.getPreviousGame() {
            game = Game(persistedObject: previousGame)
        } else {
            game = Game(answer: todayAnswer())
        }
        print(game.answer)
        lifeCount = life
        checkUpdate { updateNeeded in
            DispatchQueue.main.async {
                self.needUpdate = updateNeeded
            }}
        checkLifeCount()
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
                    HapticsManager.shared.notification(type: .success)
                    Analytics.logEvent("PlayerWin", parameters: [
                        AnalyticsParameterItemID: game.answer,
                        AnalyticsParameterLevel: game.currentRow
                    ])
                    userLog("win")
                } else if !game.didPlayerWin {
                    HapticsManager.shared.notification(type: .error)
                    Analytics.logEvent("PlayerLose", parameters: [
                        AnalyticsParameterItemID: game.answer
                    ])
                    userLog("lose")
                }
                self.isResultAnimationPlaying = true
            }
        }
    }
    
    public func presentInvalidWordWarning() {
        isInvalidWordWarningPresented = true
    }
    
    public func closeToastMessage() {
        isInvalidWordWarningPresented = false
        isADNotLoaded = false
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
    
    func generateIntToStringMonth(_ month: Int) -> String {
        let intToStringDict = ["일", "이", "삼", "사", "오", "유", "칠", "팔", "구"]
        let int10ToStringDict = ["시", "십일", "십이"]
        var ret = ""
        
        if month >= 10 {
            ret = int10ToStringDict[month % 10]
        } else {
            ret = intToStringDict[month % 10 - 1]
        }
        return ret
    }
    
    func generateIntToStringDay(_ date: Int) -> String {
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
        let todayMonth = generateIntToStringMonth(Int(lastDate.components(separatedBy: "-")[1])!) + "월 "
        let todayDay = generateIntToStringDay(Int(lastDate.components(separatedBy: "-")[2])!) + "일"
        
        return todayMonth + todayDay
    }
    
    func generateSharedGameResultString() -> String {
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
    
    func showAds() {
        guard refreshGameOnActive() == false,
              preventTapShowAdButton == false else { return }
        preventTapShowAdButton = true
        rewardADViewController.loadAD { isLoaded in
            if isLoaded {
                self.rewardADViewController.doSomething { isPresentedAd in
                    if isPresentedAd {
                        self.addLifeCountWithAD()
                        self.isADNotLoaded = false
                        self.preventTapShowAdButton = false
                    } else {
                        self.isADNotLoaded = true
                        self.preventTapShowAdButton = false
                    }
                }
            } else {
                self.isADNotLoaded = true
                self.preventTapShowAdButton = false
            }
        }
    }
    
    func showAdsWithNewGame() {
        guard refreshGameOnActive() == false,
              preventTapShowAdButton == false else { return }
        preventTapShowAdButton = true
        rewardADViewController.loadAD { isLoaded in
            if isLoaded {
                self.rewardADViewController.doSomething { isPresentedAd in
                    if isPresentedAd {
                        self.startNewGame()
                        self.isADNotLoaded = false
                        self.preventTapShowAdButton = false
                    } else {
                        self.isADNotLoaded = true
                        self.preventTapShowAdButton = false
                    }
                }
            } else {
                self.isADNotLoaded = true
                self.preventTapShowAdButton = false
            }
        }
    }
    
    private func startNewGame() {
        let randomAnswer = randomAnswerGenerator()
        let newGame = Game(answer: randomAnswer)
        self.game = newGame
        self.game.saveCurrentGame()
    }
    
    private func userLog(_ state: String) {
        let deivceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        Analytics.logEvent(state + "-" + deivceUUID, parameters: [:])
    }
    
    private func checkUpdate(completion: @escaping (Bool) -> Void) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        latestVersion { latestVersion in
            guard let latestVersion = latestVersion else { completion(false); return }
            if let lastCheckVersion = UserDefaults.standard.string(forKey: "latestVersion") {
                let compareVersion = lastCheckVersion.compare(latestVersion, options: .numeric)
                if compareVersion != .orderedAscending {
                    completion(false); return
                }
            }
            UserDefaults.standard.set(latestVersion, forKey: "latestVersion")
            
            let compareResult = appVersion?.compare(latestVersion, options: .numeric)
            
            if compareResult == .orderedAscending {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func latestVersion(completion: @escaping (String?) -> Void) {
        let appleID = "1619947572"
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)") else {
            completion(nil); return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                completion(nil); return
            }
            completion(appStoreVersion)
        }
        task.resume()
    }
    
    func openAppStore() {
        let appleID = "1619947572"
        let appStoreOpneUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
        guard let url = URL(string: appStoreOpneUrlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

/// life count
extension MainViewModel {
    func checkLifeCount() {
        if lifeTimeStamp == "" { lifeTimeStamp = dateToString(with: Date()) }
        let lastDate = stringToDate(with: lifeTimeStamp)
        let currentDate = Date()
        let diffInHours = currentDate.timeIntervalSince(lastDate) / 3600
        
        if diffInHours > 1 {
            addLifeCount(Int(lroundl(Float80(diffInHours))))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3601) { [weak self] in
            self?.checkLifeCount()
        }
    }
    
    func addLifeCountWithAD() {
        addLifeCount()
    }
    
    func addLifeCount(_ addValue: Int = 1) {
        lifeCount = min(lifeCount + addValue, 5)
        if lifeCount < 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3601) { [weak self] in
                self?.checkLifeCount()
            }
        } else {
            lifeTimeStamp = ""
        }
    }
    
    func useLifeCount() {
        guard lifeCount > 0 else {
            needLife.toggle()
            self.showAdsWithNewGame()
            return
        }
        if lifeCount == 5 {
            lifeTimeStamp = dateToString(with: Date())
            DispatchQueue.main.asyncAfter(deadline: .now() + 3601) { [weak self] in
                self?.checkLifeCount()
            }
        }
        lifeCount -= 1
        startNewGame()
    }
    
    func saveLife(lifeCount: Int) {
        if lifeCount == 5 { lifeTimeStamp = "" }
        life = lifeCount
    }
    
    func getLifeCount() {
        lifeCount = life
    }
}
