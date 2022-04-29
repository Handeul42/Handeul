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
    @AppStorage("shouldHowToPlayPresented") var shouldHowToPlayPresented: Bool = true
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
            if shouldHowToPlayPresented {
                HowToPlayView(isHowToPlayPresented: $shouldHowToPlayPresented)
                    .zIndex(2)
            }
            if mainViewModel.isInvalidWordWarningPresented == true {
                showToast("유효하지 않은 단어입니다.", status: $mainViewModel.isInvalidWordWarningPresented) {
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
                Spacer()
                GameCountView
            }
            .padding(.horizontal, 20)
            .offset(y: 5)
            AnswerBoardView()
            Spacer()
            if !mainViewModel.game.isGameFinished {
                KeyboardView()
            } else {
                DictView()
                    .disabled(!mainViewModel.game.isGameFinished)
            }
            Spacer()
        }
        .environmentObject(mainViewModel)
        .onAppear {
            requestPermission()
        }
    }
    
    private var GameCountView: some View {
        HStack(alignment: .bottom) {
            Text("No.")
                .font(.system(size: 18))
            ZStack {
                Text("\(mainViewModel.game.gameNumber)")
                    .font(.system(size: 28))
                Rectangle()
                    .frame(width: 56, height: 2)
                    .offset(y: 16)
            }
            .frame(width: 56, height: 32)
        }
        .foregroundColor(.hRed)
    }
}
