//
//  MainViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAnalytics
import GoogleMobileAds

class MainViewModel: ObservableObject {
    @Published var game: Game
    
    @Published var hintRow: [Key]
    @Published var isHintRevealed: Bool = false
    @Published var CurrentHintCount: Int = 0
    
    @Published var needLife: Bool = false
    @Published var lifeCount: Int = 0 {
        didSet {
            saveLife(lifeCount: lifeCount)
        }
    }
    
    @Published var isResultAnimationPlaying: Bool = false
    @Published var isInvalidWordWarningPresented: Bool = false
    
    @Published var isADNotLoaded: Bool = false
    
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
        markCorrectJamoOnHint()
        lifeCount = life
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
}

/// Ad
extension MainViewModel {
    
    func presentAdFor(for action: @escaping () -> Void) {
        guard !refreshGameOnActive() && !preventTapShowAdButton else { return }
        
        preventTapShowAdButton = true
        isADNotLoaded = true
        DispatchQueue.main.async {
            self.rewardADViewController.loadAD { [weak self] isLoaded in
                if isLoaded {
                    self?.rewardADViewController.doSomething { isPresentedAd in
                        self?.isADNotLoaded = !isPresentedAd
                        if isPresentedAd { action() }
                    }
                }
                self?.preventTapShowAdButton = false
            }
        }
    }
    
    func startNewGameWithAd() {
        presentAdFor { self.startNewGame() }
    }
    
    func addLifeCountWithAD() {
        presentAdFor { self.addLifeCount() }
    }
    
    func showHintWithAd(revealHintAt index: Int) {
        presentAdFor {
            self.setHint(at: index)
            self.isHintRevealed = true
        }
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
            addLifeCount(Int(lroundl(diffInHours)))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3601) { [weak self] in
            self?.checkLifeCount()
        }
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
            self.startNewGameWithAd()
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
    func setHint(at index: Int) {
        let answer = self.game.answer
        let jamo = String(answer[answer.index(answer.startIndex, offsetBy: index)])
        self.hintRow[index] = Key(character: jamo, status: .green)
        self.game.keyBoard.changeKeyStatus(to: .green, keyLabel: jamo)
        self.CurrentHintCount += 1
    }
    
    func clearHint() {
        self.hintRow = Self.getEmptyHintRow(length: game.jamoCount)
        self.CurrentHintCount = 0
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
