//
//  AnswerBoardView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct AnswerBoardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    private func horline(width: CGFloat) -> some View {
        return Rectangle()
            .fill(Color.hRed)
            .frame(width: uiSize.width - 40, height: width)
//            .edgesIgnoringSafeArea(.horizontal)
    }
    
    func answerBoardButton(_ key: Key) -> some View {
        let keyButtonSize: CGSize = CGSize(width: 56, height: 56)
        return ZStack {
            Rectangle()
                .frame(width: keyButtonSize.width,
                       height: keyButtonSize.height)
                .foregroundColor(getColor(of: key.status))
                .border(Color.hRed, width: 2)
            Text(key.character)
                .foregroundColor(.black)
        }
    }
    
    var body: some View {
        VStack (spacing: -2) {
            horline(width: 3)
                .padding([.bottom], 5)
            ForEach(viewModel.rows, id: \.self) { row in
                horline(width: 2)
//                    .padding([.top], 5)
//                    .padding([.bottom], -5)
                HStack {
                    ForEach(row) { btn in
                        Button {
                            print(btn.character)
                        } label: {
                            answerBoardButton(btn)
                        }
                    }
                    .padding([.horizontal], -5)
                }
                horline(width: 2)
//                    .padding([.top], -5)
                    .padding([.bottom], 4)
            }
            horline(width: 3)
        }
    }
}
