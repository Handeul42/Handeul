//
//  AnswerBoardViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

class AnswerBoardViewModel: ObservableObject {
    
    @Published var rows: [[Key]] =
    Array(repeating: Range(0...5).map { _ in
        Key(character: " ")
    }, count: 6)
    
    var currentRow: Int = 0
    var currentColumn: Int = 0
    
    func appendReceivedCharacter(of receivedKeyCharacter: String) {
        if currentColumn <= 5 {
            rows[currentRow][currentColumn].character = receivedKeyCharacter
            currentColumn += 1
        }
    }
    
    func deleteOneCharacter() {
        if currentColumn != 0 {
            currentColumn -= 1
            rows[currentRow][currentColumn].character = ""
        }
    }
    
    func submitAnswer() {
        if currentColumn == 6 {
            //제출하는 함수
            currentRow += 1
            currentColumn = 0
        }
    }
    
    //    @Published var firstRow: [Key]
    //    @Published var secondRow: [Key]
    //    @Published var thirdRow: [Key]
    //    @Published var fourthRow: [Key]
    //    @Published var fifthRow: [Key]
    //    @Published var sixthRow: [Key]
    
    //        self.firstRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
    //        self.secondRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
    //        self.thirdRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
    //        self.fourthRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
    //        self.fifthRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
    //        self.sixthRow = Range(0...5).map { _ in
    //            Key(character: " ")
    //        }
}
