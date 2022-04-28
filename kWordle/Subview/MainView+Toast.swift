//
//  MainView+ToastView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/20.
//

import SwiftUI

struct ToastView: View {
    
    @Binding var presentStatus: Bool
    
    let toastText: String
    var body: some View {
        Text(toastText)
            .font(.custom("EBSHMJESaeronR", size: 16))
            .foregroundColor(Color.hBlack)
            .padding()
            .background(Color.hLigthGray
                .opacity(0.95)
                .cornerRadius(8)
            )
            .onTapGesture {
                withAnimation {
                    self.presentStatus = false
                }
            }
    }
}
extension View {
    func showToast(_ message: String, status: Binding<Bool>, changeStatusBy: @escaping () -> Void) -> some View {
        ToastView(presentStatus: status, toastText: message)
            .zIndex(2)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    withAnimation {
                        changeStatusBy()
                    }
                }
            }
    }
}
