//
//  String+getChar.swift
//  한들
//
//  Created by JaemooJung on 2022/04/22.
//

import Foundation

extension String {
    func getChar(at index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
