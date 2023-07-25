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
            .font(.custom("EBSHMJESaeronR", fixedSize: 16))
            .lineSpacing(10)
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    withAnimation {
                        presentStatus = false
                    }
                }
            }
            .zIndex(99)
    }
}

#if DEBUG
import SwiftUI

struct ToastPreview: PreviewProvider {
    static var previews: some View {
        Group {
            Text("다음 문제를 위해\n광고 불러오는 중")
                .font(.custom("EBSHMJESaeronR", fixedSize: 16))
                .lineSpacing(10)
                .foregroundColor(Color.hBlack)
                .padding()
                .background(Color.hLigthGray
                    .opacity(0.95)
                    .cornerRadius(8)
                )
        }
    }
}
#endif
