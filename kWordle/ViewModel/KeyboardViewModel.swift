//
//  KeyboardViewModel.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

class KeyboardViewModel: ObservableObject {
    let firstRowLabel = ["ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅛ", "ㅕ", "ㅑ"]
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
    
    func changeKeyStatus(to status: Status, keyLabel: String) {
        for idx in firstRow.indices where firstRow[idx].character == keyLabel {
            firstRow[idx].status = status
        }
        for idx in secondRow.indices where secondRow[idx].character == keyLabel {
            secondRow[idx].status = status
        }
        for idx in thirdRow.indices where thirdRow[idx].character == keyLabel {
            thirdRow[idx].status = status
        }
    }
}
