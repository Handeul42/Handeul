//
//  KeyBoard.swift
//  한들
//
//  Created by JaemooJung on 2022/04/25.
//

import Foundation

struct KeyBoard: Codable {
    private(set) var firstRow: [Key]
    private(set) var secondRow: [Key]
    private(set) var thirdRow: [Key]

    init(firstRow: [Key], secondRow: [Key], thirdRow: [Key]) {
        self.firstRow = firstRow
        self.secondRow = secondRow
        self.thirdRow = thirdRow
    }
    
    mutating func changeKeyStatus(to status: Status, keyLabel: String) {
        for idx in firstRow.indices where firstRow[idx].character == keyLabel {
            if firstRow[idx].status != .green {
                firstRow[idx].changeStatus(to: status)
            }
        }
        for idx in secondRow.indices where secondRow[idx].character == keyLabel {
            if secondRow[idx].status != .green {
                secondRow[idx].changeStatus(to: status)
            }
        }
        for idx in thirdRow.indices where thirdRow[idx].character == keyLabel {
            if thirdRow[idx].status != .green {
                thirdRow[idx].changeStatus(to: status)
            }
        }
    }
}
