//
//  File.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import Foundation
import SwiftUI

extension Color {
    static let hOrange = Color("h_orange")
    static let hRed = Color("h_red")
    static let hGreen = Color("h_green")
    static let hGray = Color("h_gray")
    static let hLigthGray = Color("h_lightGray")
    static let hWhite = Color("h_white")
    static let hBlack = Color("h_black")
}

enum Status: Int {
    case gray
    case yellow
    case green
    case lightGray
    case red
    case white
    case black
}

func getColor(of status: Status) -> Color {
    switch status {
    case .gray:
        return Color.hGray
    case .lightGray:
        return Color.hLigthGray
    case .green:
        return Color.hGreen
    case .yellow:
        return Color.hOrange
    case .red:
        return Color.hRed
    case .white:
        return Color.hWhite
    case .black:
        return Color.hBlack
    }
}
