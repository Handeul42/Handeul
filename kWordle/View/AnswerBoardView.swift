//
//  AnswerBoardView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct AnswerBoardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    let keyButtonWidth: Double = Double(uiSize.width - 40) / 6

    private func horline(width: CGFloat) -> some View {
        return Rectangle()
            .fill(Color.hRed)
            .frame(width: uiSize.width - 40, height: width)
    }
    
    func answerBoardBlock(_ key: Key) -> some View {
        let keyButtonSize: CGSize = CGSize(width: keyButtonWidth, height: keyButtonWidth)
        return ZStack {
            Rectangle()
                .frame(width: keyButtonSize.width,
                       height: keyButtonSize.height)
                .foregroundColor(getColor(of: key.status))
                .border(Color.hRed, width: 2)
            Text(key.character)
                .foregroundColor(getColor(of: .black))
                .font(.custom("EBSHMJESaeronSB", fixedSize: 32))
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: -2) {
                horline(width: 3)
                    .padding([.bottom], 5)
                ForEach(viewModel.game.answerBoard, id: \.self) { row in
                    horline(width: 2)
                    HStack {
                        ForEach(row) { btn in
                            answerBoardBlock(btn)
                        }
                        .padding([.horizontal], -5)
                    }
                    horline(width: 2)
                        .padding([.bottom], 4)
                }
                horline(width: 3)
            }
            .animation(.none)
            Image("Filcrow")
                .resizable()
                .frame(width: 12, height: 16)
                .offset(x: (Double(viewModel.game.currentColumn + 1) - 2.5) * (keyButtonWidth - 2) - 43,
                        y: (Double(viewModel.game.currentRow) - 2.5) * keyButtonWidth + 10)
        }
    }
}
