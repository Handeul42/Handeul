//
//  Key.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation
import RealmSwift
import Realm

struct Key: Identifiable, Hashable, Codable {
    
    private(set) var id = UUID()
    private(set) var character: String
    private(set) var status: Status = .lightGray
    
    public mutating func changeStatus(to status: Status) {
        self.status = status
    }
    
    public mutating func changeCharacter(to char: String) {
        self.character = char
    }
}
