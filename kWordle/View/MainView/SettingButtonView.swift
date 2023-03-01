//
//  SettingButtonView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/01.
//

import SwiftUI

struct SettingButtonView: View {
    @Binding var isSettingPresented: Bool
    let buttonSize: CGFloat = 32
    var body: some View {
        Button {
            withAnimation {
                isSettingPresented.toggle()
            }
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(.hBlack)
        }
    }
}
