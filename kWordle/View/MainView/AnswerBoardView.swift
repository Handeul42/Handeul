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
    
    var body: some View {
        ZStack {
            VStack(spacing: -2) {
                Horline(height: 3)
                    .padding([.bottom], 5)
                ForEach(answerBoard.indices, id: \.self) { rowIndex in
                    let row: [Key] = answerBoard[rowIndex]
                    AnswerBoardRow(row: row)
                        .padding([.bottom], 5)
                }
                Horline(height: 3)
            }
            Image("Filcrow")
                .resizable()
                .frame(width: 12, height: 16)
                .offset(x: (Double(currentColumn + 1) - 2.5) * (keyButtonWidth - 2) - 43,
                        y: (Double(currentRow) - 2.5) * keyButtonWidth + 10)
        }
    }
}

struct AnswerBoardRow: View {
    let row: [Key]
    
    var body: some View {
        VStack(spacing: -2) {
            Horline(height: 2)
            HStack(spacing: -2) {
                ForEach(row) { btn in
                    AnswerBoardBlock(key:btn, blockSize: keyButtonWidth)
                }
            }
            Horline(height: 2)
        }
    }
}

struct AnswerBoardBlock: View {
    let key: Key
    let blockSize: CGFloat
    
    var body: some View {
        let keyButtonSize: CGSize = CGSize(width: blockSize, height: blockSize)
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
}
