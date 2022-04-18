//
//  wordDictManager.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation
import CoreData
import SwiftUI

class WordDictManager {
    
    init() {
    }
    
    static func initWordDB() {
        var words: String = ""
        let persistenceController = PersistenceController()
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
            let word = FiveWords(context: persistenceController.container.viewContext)
            word.word = columns[0]
            word.jamo = columns[1]
            word.dict = columns[2]
        }
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        UserDefaults.standard.set(true, forKey: "isDBinited")
    }
    
    func readDB() {
        
    }
    static func makeWordDict() -> [WordDict] {
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

//    func getWordOfToday() -> String {
//
//    }
}
func saveDataToCoreData() {
    
}
