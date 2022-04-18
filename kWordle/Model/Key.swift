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
    var status: Status = .gray
}

enum Status: Int {
    case gray
    case yellow
    case green
    case lightGray
}
