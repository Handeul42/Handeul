//
//  PlayedGameView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/08.
//

import SwiftUI

struct PlayedGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let game: Game
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    GameNumberView(count: game.gameNumber)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                }
                AnswerBoardView(answerBoard: game.answerBoard,
                                currentColumn: game.currentColumn,
                                currentRow: game.currentRow)
                DictView(game: game)
                    .padding(.vertical, 24)
                Spacer()
                backButton
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("뒤로")
                .font(.custom("EBSHMJESaeronR", fixedSize: 18))
                .foregroundColor(.hBlack)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.hLigthGray)
                .cornerRadius(4)
                
        }
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct PlayedGameView_Previews: PreviewProvider {
    static var previews: some View {
        let mockGame: Game = Game(answer: "ㅁㅕㅇㅈㅜ")
        PlayedGameView(game: mockGame)
    }
}
    
