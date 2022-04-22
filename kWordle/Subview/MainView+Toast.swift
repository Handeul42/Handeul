//
//  MainView+ToastView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/20.
//

import SwiftUI

struct ToastView: View {
    let toastText: String
    var body: some View {
        Text(toastText)
            .font(.custom("EBSHMJESaeronR", size: 16))
            .foregroundColor(Color.black)
            .padding()
            .background(Color.hLigthGray
                .opacity(0.95)
                .cornerRadius(8)
            )
    }
}
extension View {
    func showToast(_ message: String, changeStatusBy: @escaping () -> Void) -> some View {
        ToastView(toastText: message)
            .zIndex(2)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    withAnimation {
                        changeStatusBy()
                    }
                }
            }
    }
}
