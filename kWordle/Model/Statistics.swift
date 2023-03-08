//
//  Statistics.swift
//  한들
//
//  Created by JaemooJung on 2022/04/26.
//

import Foundation
import RealmSwift
import SwiftUI

struct Statistics {
    
    private let currentGames = RealmManager.shared.getAllGames().sorted(byKeyPath: "timestamp", ascending: false).where({ $0.isGameFinished == true })
    
    private(set) var totalPlayed: Int = 0
    private(set) var win: Int = 0
    private(set) var winRatio: Float = 0
    private(set) var currentWinStreak: Int = 0
    private(set) var maxWinStreak: Int = 0
    private(set) var playerTryForWin: [Int] = [0, 0, 0, 0, 0, 0]
    
    init() {
        guard !currentGames.isEmpty else { return }
        totalPlayed = currentGames.count
        win = currentGames.filter({ $0.didPlayerWin == true }).count
        currentWinStreak = Self.getCurrentWinStreak(currentGames)
        maxWinStreak = Self.getMaxWinStreak(currentGames)
        winRatio = Float(win) / Float(totalPlayed) * 100
        playerTryForWin = (0...5).map { getPlayerTryForWin($0) }
    }
    
    public func getTryRatio(_ idx: Int) -> CGFloat {
        let max = playerTryForWin.max() ?? 0
        if max == 0 { return 0 }
        return CGFloat(Float(playerTryForWin[idx]) / Float(max))
    }
    
    private func getPlayerTryForWin(_ number: Int) -> Int {
        guard !currentGames.isEmpty else { return 0 }
        return currentGames.filter({ $0.currentRow == number && $0.didPlayerWin == true }).count
    }
    
    static private func getCurrentWinStreak(_ games: Results<PersistedGame>) -> Int {
        var currentWinStreak = 0
        for game in games {
            if game.didPlayerWin {
                currentWinStreak += 1
            } else {
                break
            }
        }
        return currentWinStreak
    }
    
    static private func getMaxWinStreak(_ games: Results<PersistedGame>) -> Int {
        var maxWinStreak = 0
        var currentWinStreak = 0
        for game in games {
            if game.didPlayerWin == true {
                currentWinStreak += 1
                if currentWinStreak > maxWinStreak {
                    maxWinStreak = currentWinStreak
                }
            } else {
                currentWinStreak = 0
            }
        }
        return maxWinStreak
    }
}
