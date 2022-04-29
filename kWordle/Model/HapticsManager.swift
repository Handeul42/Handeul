//
//  HapticsManager.swift
//  한들
//
//  Created by JaemooJung on 2022/04/28.
//

import Foundation
import AVFoundation
import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {
        
    }

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func playSound(id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}

