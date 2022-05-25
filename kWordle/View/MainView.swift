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
                    } else if newScenePhase == .active {
                        withAnimation {
                          _ = mainViewModel.refreshGameOnActive()
                        }
                    }
                    mainViewModel.closeInvalidWordWarning()
                }
            if isSettingPresented {
                SettingView(isSettingPresented: $isSettingPresented)
                    .zIndex(1)
                    .environmentObject(mainViewModel)
            }
            if shouldHowToPlayPresented {
                HowToPlayOnFirstLaunch(isHowToPlayPresented: $shouldHowToPlayPresented)
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
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    TitleView()
                        .padding(.top, 35 * currentScreenRatio())
                        .padding(.bottom, 8 * currentHeightRatio())
                        HStack {
                            SettingButtonView(isSettingPresented: $isSettingPresented)
                            Spacer()
                            GameCountView
                        }
                }
                ZStack {
                    Image("StreakBubble")
                        .resizable()
                        .frame(width: 80, height: 55)
                    VStack {
                        HStack(spacing: 0) {
                            Text("1000")
                                .foregroundColor(.hBlack)
                                .font(.system(size: 14, weight: .medium))
                            Text("번째")
                                .foregroundColor(.hBlack)
                                .font(.custom("EBSHMJESaeronSB", size: 14))
                        }
                        Text("연승중")
                            .foregroundColor(.hBlack)
                            .font(.custom("EBSHMJESaeronSB", size: 14))
                    }
                    .padding(.bottom, 6)
                }
                .padding(.trailing, 35)
                .padding(.bottom, 25)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
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
