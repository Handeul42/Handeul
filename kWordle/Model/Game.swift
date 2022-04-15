//
//  Game.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

struct Game {
    let answer: String
    var userAnswer: Answer
    let wordDict: [String: String]
    let key: [Key]
}
