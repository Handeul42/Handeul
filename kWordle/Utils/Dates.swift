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
    let rtrn = dateformatter.string(from: dateForString)
    return rtrn
}

func stringToDate(with dateString: String) -> Date {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

    let date: Date = dateFormatter.date(from: dateString)!
    return date
}

func dateToString(with date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

    let dateString: String = dateFormatter.string(from: date)
    return dateString
}
