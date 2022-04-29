//
//  SettingToggleStyle.swift
//  한들
//
//  Created by 강희영 on 2022/04/27.
//

import SwiftUI

struct SettingToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        HStack(spacing: 0) {
            Image(systemName: configuration.isOn ? "chevron.down" : "chevron.right")
                .font(.system(size: 12))
                .frame(width: 12, height: 12)
                .offset(x: -20)
            configuration.label
                .offset(x: -12)
            Spacer()
            Button {
                withAnimation {
                    configuration.isOn.toggle()
                }
            } label: {
                ZStack {
                    if !configuration.isOn {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.hBlack, lineWidth: 1)
                            .frame(width: 22, height: 14)
                            .foregroundColor(.hLigthGray)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 22, height: 14)
                            .foregroundColor(.hBlack)
                    }
                    Image(systemName: "circlebadge.fill")
                        .resizable()
                        .frame(width: 6, height: 6)
                        .offset(x: configuration.isOn ? 4 : -4)
                        .foregroundColor(configuration.isOn ? .hLigthGray : .hBlack)
                }
            }
        }
    }
}
