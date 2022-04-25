//
//  constant+UIscreenSize.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import UIKit

let uiSize: CGSize = UIScreen.main.bounds.size
let keyboardWidth: CGFloat = (uiSize.width - 100) / 10
let keyboardHeight: CGFloat = 40

func currentScreenRatio() -> CGFloat {
    return (uiSize.width * uiSize.height) / (390 * 844)
}
