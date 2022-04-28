//
//  Dates.swift
//  한들
//
//  Created by JaemooJung on 2022/04/28.
//

import Foundation

func getTodayDateString() -> String {
    
    let dateformatter: DateFormatter = {
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()
    let dateForString = Date()
    return dateformatter.string(from: dateForString)
}

