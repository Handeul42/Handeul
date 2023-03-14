//
//  HapticsManager.swift
//  한들
//
//  Created by JaemooJung on 2022/04/28.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

class HapticsManager {
        
    static let shared = HapticsManager()

    private init() {
        
    }

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard !UserDefaults.standard.bool(forKey: "isHapticFeedbackOff") else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard !UserDefaults.standard.bool(forKey: "isHapticFeedbackOff") else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func playSound(id: SystemSoundID) {
        guard !UserDefaults.standard.bool(forKey: "isSoundOff") else { return }
        AudioServicesPlaySystemSound(id)
    }
}
