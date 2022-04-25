//
//  KeyBoard.swift
//  한들
//
//  Created by JaemooJung on 2022/04/25.
//

import Foundation

struct KeyBoard {
    var firstRow = [Key]()
    var secondRow = [Key]()
    var thirdRow = [Key]()
    
    mutating func changeKeyStatus(to status: Status, keyLabel: String) {
        for idx in firstRow.indices where firstRow[idx].character == keyLabel {
            if firstRow[idx].status != .green {
                firstRow[idx].status = status
            }
        }
        for idx in secondRow.indices where secondRow[idx].character == keyLabel {
            if secondRow[idx].status != .green {
                secondRow[idx].status = status
            }
        }
        for idx in thirdRow.indices where thirdRow[idx].character == keyLabel {
            if thirdRow[idx].status != .green {
                thirdRow[idx].status = status
            }
        }
    }
}
