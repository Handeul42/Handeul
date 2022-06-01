//
//  wordDictManager.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

class WordDictManager {
    static let shared = WordDictManager()
    let wordDictFiveJamo: [WordDict]
    
    private init() {
        self.wordDictFiveJamo = Self.makeWordDict()
    }
    
    private static func makeWordDict() -> [WordDict] {
        var dict = [WordDict]()
        var words: String = ""
        
        if let path = Bundle.main.path(forResource: "5Jamo.tsv", ofType: nil) {
            do {
                words = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                print(error)
            }
        } else {
            print("Cannot Find Path")
        }
        let rows = words.components(separatedBy: "\n")
        for row in rows where row.isEmpty == false {
            let columns = row.components(separatedBy: "\t")
            let wordDict = WordDict(word: columns[0], jamo: columns[1], meaning: columns[2])
            dict.append(wordDict)
        }
        return dict
    }
}
