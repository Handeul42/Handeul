//
//  MainView+MenuBar.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

// Not used for now
struct MenuBar: View {
    @Binding var isHowToPlayPresented: Bool
    @Binding var isStatisticsPresented: Bool
    @Binding var isSettingPresented: Bool
    let buttonSize: CGFloat = 28 * currentScreenRatio()
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    isHowToPlayPresented.toggle()
                }
            } label: {
                Image(systemName: "questionmark.square").font(.system(size: buttonSize))
            }
            Spacer()
            Button {
                withAnimation {
                    isStatisticsPresented.toggle()
                }
            } label: {
                Image(systemName: "chart.bar").font(.system(size: buttonSize))
            }
            Button {
                withAnimation {
                    isSettingPresented.toggle()
                }
            } label: {
                Image(systemName: "gearshape").font(.system(size: buttonSize))
            }
        }
        .foregroundColor(getColor(of: .black))
        .padding([.leading, .trailing])
        .padding(.bottom, 8)
    }
}
