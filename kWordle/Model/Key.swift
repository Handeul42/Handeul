//
//  Key.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import Foundation

struct Key: Identifiable, Hashable {
    let id = UUID()
    var character: String
    var status: Status = .lightGray
}
