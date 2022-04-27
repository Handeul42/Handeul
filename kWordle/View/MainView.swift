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
    let wordDictManager = WordDictManager()
    var body: some View {
        ZStack {
            mainView
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .active {
                        mainViewModel.refreshGameOnActive()
                    }
                }
            if isHowToPlayPresented {
                HowToPlayView(isHowToPlayPresented: $isHowToPlayPresented)
                    .zIndex(1)
            }
//            if isStatisticsPresented {
//                StatisticView(isStatisticsPresented: $isStatisticsPresented)
//            }
            if mainViewModel.isWordValid == false {
                showToast("유효하지 않은 단어입니다.") {
                    mainViewModel.toggleValidWordState()
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
            if !mainViewModel.isGameFinished {
                KeyboardView()
            } else {
                DictView()
            }
            Spacer()
        }
        .environmentObject(mainViewModel.keyboardViewModel)
        .environmentObject(mainViewModel)
    }
}
