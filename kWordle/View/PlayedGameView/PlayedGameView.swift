//
//  PlayedGameView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import SwiftUI

struct PlayedGameView: View {
    
    let game: Game
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                GameNumberView(count: game.gameNumber)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
            AnswerBoardView(answerBoard: game.answerBoard,
                            currentColumn: game.currentColumn,
                            currentRow: game.currentRow)
            DictView(currentGame: game) {
                
            }
        }

    }
}

struct PlayedGameView_Previews: PreviewProvider {
    static var previews: some View {
        PlayedGameView(game: Game(answer: "ㅁㅕㅇㅈㅜ"))
    }
}
