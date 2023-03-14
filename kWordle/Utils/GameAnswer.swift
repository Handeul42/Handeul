//
//  GameAnswerGenerator.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import Foundation

var generator = RandomNumberGeneratorWithSeed(seed: DateToSeed())

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
