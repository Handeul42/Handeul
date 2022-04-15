//
//  MainView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var answerBoardViewModel: AnswerBoardViewModel = AnswerBoardViewModel()
    let wordDictManager = WordDictManager()
    var body: some View {
        VStack {
            AnswerBoardView()
            KeyboardView()
        }.environmentObject(self.answerBoardViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
