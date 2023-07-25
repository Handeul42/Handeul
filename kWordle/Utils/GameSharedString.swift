//
//  GameSharedString.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import Foundation

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

func generateSharedGameResultString(game: Game) -> String {
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
            case .gray: 
                ret += "⬜️"
            case .green: 
                ret += "🟩"
            case .yellow: 
                ret += "🟧"
            case .white, .red, .lightGray, .black:
                break
            }
        }
        ret += "\n"
    }
    return "\(date)\n\(title)\n\(streak)\n\(appAddress)\n" + ret.trimmingCharacters(in: .newlines)
}
