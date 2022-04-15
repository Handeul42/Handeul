//
//  wordDictManager.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

class WordDictManager {
    
    var words: String = ""
    
    init() {
        if let path = Bundle.main.path(forResource: "6Words/6Jamo.csv", ofType: nil) {
            do {
                words = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        } else {
            print("Cannot Find Path")
        }
    }
    
    func makeWordDict() -> [String: String] {
        var dict = [String: String]()
        let rows = words.components(separatedBy: "\n")
        for row in rows where row.isEmpty == false {
                let columns = row.components(separatedBy: ":")
                dict[columns[0]] = columns[1].trimmingCharacters(in: .whitespaces)
        }
        return dict
    }

//    func getWordOfToday() -> String {
//
//    }
}
