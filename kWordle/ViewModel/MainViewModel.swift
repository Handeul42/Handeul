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
    @Published var hintRow: [Key]
    @Published var isInvalidWordWarningPresented: Bool = false
    @Published var isADNotLoaded: Bool = false
    @Published var isHintRevealed: Bool = false
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
        hintRow = Self.getEmptyHintRow(length: 5)
        lifeCount = life
        checkUpdate { updateNeeded in
            DispatchQueue.main.async {
                self.needUpdate = updateNeeded
            }}
        checkLifeCount()
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
                HapticsManager.shared.notification(type: .warning)
                return
            }
            game.submitAnswer()
            markCorrectJamoOnHint()
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
        clearHint()
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

/// For hint
extension MainViewModel {
    func showHintWithAd(revealHintAt index: Int) {
        guard refreshGameOnActive() == false,
              preventTapShowAdButton == false else { return }
        preventTapShowAdButton = true
        rewardADViewController.loadAD { isLoaded in
            if isLoaded {
                self.rewardADViewController.doSomething { [self] isPresentedAd in
                    if isPresentedAd {
//                      Show Hint --------------------------
                        self.setHint(at: index)
                        self.isHintRevealed = true
// ---------------------------------------------------------
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
    
    func setHint(at index: Int) {
        let answer = self.game.answer
        let jamo = String(answer[answer.index(answer.startIndex, offsetBy: index)])
        self.hintRow[index] = Key(character: jamo, status: .green)
        self.game.keyBoard.changeKeyStatus(to: .green, keyLabel: jamo)
    }
    
    func clearHint() {
        self.hintRow = Self.getEmptyHintRow(length: game.jamoCount)
    }
    
    private func markCorrectJamoOnHint() {
        let answerRowIndex = game.currentRow - 1 < 0 ? 0 : game.currentRow - 1
        _ = self.game.answerBoard[answerRowIndex].enumerated().map { (index, key) in
            if key.status == .green {
                self.hintRow[index] = key
            }
        }
    }
    
    static func getEmptyHintRow(length: Int) -> [Key] {
        return [Key](repeating: Key(id: UUID(), character: "", status: .lightGray), count: length)
    }
}
