//
//  AnswerBoardView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct AnswerBoardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        VStack {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack {
                    ForEach(row) { btn in
                        Button {
                            print(btn.character)
                        } label: {
                            keyboardButton(btn)
                        }
                    }
                }
            }
        }
    }
}

struct AnswerBoardView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerBoardView()
    }
}
