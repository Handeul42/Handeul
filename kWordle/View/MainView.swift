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
    
    @State var isHowToPlayPresented: Bool = false
    @State var isStatisticsPresented: Bool = false
    @State var isSettingPresented: Bool = false
    
    var body: some View {
        ZStack {
            mainView
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .inactive {
                        mainViewModel.game.saveCurrentGame()
                    }
                    mainViewModel.closeInvalidWordWarning()
                }
            if isHowToPlayPresented {
                HowToPlayView(isHowToPlayPresented: $isHowToPlayPresented)
                    .zIndex(1)
            }
            if isStatisticsPresented {
                StatisticsView(isStatisticsPresented: $isStatisticsPresented)
                    .zIndex(2)
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
                .padding(.top, 35)
            MenuBar(isHowToPlayPresented: $isHowToPlayPresented,
                    isStatisticsPresented: $isStatisticsPresented,
                    isSettingPresented: $isSettingPresented)
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
