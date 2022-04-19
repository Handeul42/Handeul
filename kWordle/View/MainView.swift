//
//  MainView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct MainView: View {
//    @ObservedObject var answerBoardViewModel: AnswerBoardViewModel = AnswerBoardViewModel()
    @ObservedObject var mainViewModel: MainViewModel = MainViewModel()
    
    let wordDictManager = WordDictManager()
    var body: some View {
        VStack {
            Spacer()
            TitleView()
            AnswerBoardView()
            Spacer()
            KeyboardView()
            Spacer()
        }
        .environmentObject(mainViewModel.keyboardViewModel)
        .environmentObject(mainViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
