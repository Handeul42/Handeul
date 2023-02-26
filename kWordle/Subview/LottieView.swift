//
//  LottieView.swift
//  한들
//
//  Created by JaemooJung on 2023/02/26.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let filename: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    let animationView: LottieAnimationView
    
    @Binding var isPlayed: Bool
    
    init(_ filename: String,
         loopMode: LottieLoopMode = .playOnce,
         animationSpeed: CGFloat = 1,
         contentMode: UIView.ContentMode = .scaleAspectFit,
         isPlayed: Binding<Bool> = .constant(true)
    ) {
        self.filename = filename
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
        self.animationView = LottieAnimationView(name: filename)
        self._isPlayed = isPlayed
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isPlayed {
            animationView.play { _ in
                withAnimation {
                    isPlayed = false
                }
            }
        }
    }
}
