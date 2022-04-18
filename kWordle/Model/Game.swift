//
//  Game.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

struct Game {
    var answer: String
    var userAnswer: Answer
    var wordDict: [WordDict]
    var key: [Key]
    
    init() {
        answer = ""
        userAnswer = Answer(keys: [[]])
        wordDict = []
        key = []
    }
}
