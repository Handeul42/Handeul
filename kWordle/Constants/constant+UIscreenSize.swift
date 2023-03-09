//
//  constant+UIscreenSize.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import UIKit

let uiSize: CGSize = UIScreen.main.bounds.size
let UIHeight: CGFloat = uiSize.height
let UIWidth: CGFloat = uiSize.width
let keyboardWidth: CGFloat = (uiSize.width - 100) / 10
let keyboardHeight: CGFloat = 40

let keyButtonWidth: Double = Double(uiSize.width - 40) / 6

func currentScreenRatio() -> CGFloat {
    return (uiSize.width * uiSize.height) / (390 * 844)
}

func currentHeightRatio() -> CGFloat {
    return uiSize.height / 844
}
