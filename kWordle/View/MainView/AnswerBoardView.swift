//
//  AnswerBoardView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct AnswerBoardView: View {
    let answerBoard: [[Key]]
    let currentColumn: Int
    let currentRow: Int
    let keyButtonWidth: Double = Double(uiSize.width - 40) / 6
    
    var body: some View {
        ZStack {
            VStack(spacing: -2) {
                Horline(height: 3)
                    .padding([.bottom], 5)
                ForEach(answerBoard.indices, id: \.self) { rowIndex in
                    let row: [Key] = answerBoard[rowIndex]
                    AnswerBoardRow(row)
                }
                Horline(height: 3)
            }.transition(.opacity)
            .animation(.easeInOut)
            Image("Filcrow")
                .resizable()
                .frame(width: 12, height: 16)
                .offset(x: (Double(currentColumn + 1) - 2.5) * (keyButtonWidth - 2) - 43,
                        y: (Double(currentRow) - 2.5) * keyButtonWidth + 10)
        }
    }
}

extension AnswerBoardView {
    @ViewBuilder
    func answerBoardBlock(_ key: Key) -> some View {
        let keyButtonSize: CGSize = CGSize(width: keyButtonWidth, height: keyButtonWidth)
        ZStack {
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
    
    @ViewBuilder
    fileprivate func AnswerBoardRow(_ row: [Key]) -> some View {
        Horline(height: 2)
        HStack {
            ForEach(row) { btn in
                answerBoardBlock(btn)
            }
            .padding([.horizontal], -5)
        }
        Horline(height: 2)
            .padding([.bottom], 4)
    }
}
