//
//  MainView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var mainViewModel: MainViewModel = MainViewModel()
    
    @State var isSettingPresented: Bool = false
    
    var body: some View {
        ZStack {
            mainView
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .inactive {
                        if !mainViewModel.game.isGameFinished {
                            mainViewModel.game.saveCurrentGame()
                        }
                    }
                    mainViewModel.closeInvalidWordWarning()
                }
            if isSettingPresented {
                SettingView(isSettingPresented: $isSettingPresented)
                    .zIndex(1)
            }
            if mainViewModel.isInvalidWordWarningPresented == true {
                showToast("유효하지 않은 단어입니다.") {
                    mainViewModel.closeInvalidWordWarning()
                }
            }
        }
    }
    var mainView: some View {
        VStack {
            TitleView()
                .padding(.top, 35 * currentScreenRatio())
            HStack {
                SettingButtonView(isSettingPresented: $isSettingPresented)
                    .padding(.leading, 20)
                Spacer()
            }
            AnswerBoardView()
            Spacer()
            if !mainViewModel.game.isGameFinished {
                KeyboardView()
            } else {
                DictView()
            }
            Spacer()
        }.environmentObject(mainViewModel)
    }
}
