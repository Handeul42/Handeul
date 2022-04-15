//
//  KeyboardViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

class KeyboardViewModel: ObservableObject {
    let firstRowLabel = ["ㅂ", "ㅈ", "ㄷ", "ㅅ", "ㅛ", "ㅕ", "ㅑ"]
    let secondRowLabel = ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅗ", "ㅓ", "ㅏ", "ㅣ"]
    let thirdRowLabel = ["ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ"]
    @Published var firstRow: [Key]
    @Published var secondRow: [Key]
    @Published var thirdRow: [Key]
    
    init() {
        self.firstRow = firstRowLabel.map {
            Key(character: $0)
        }
        self.secondRow = secondRowLabel.map {
            Key(character: $0)
        }
        self.thirdRow = thirdRowLabel.map {
            Key(character: $0)
        }
    }
    
    
}
