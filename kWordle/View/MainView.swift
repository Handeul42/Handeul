//
//  MainView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
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
                    mainViewModel.closeToastMessage()
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
            if mainViewModel.isInvalidWordWarningPresented {
                showToast("유효하지 않은 단어입니다.", status: $mainViewModel.isInvalidWordWarningPresented) {
                    mainViewModel.closeToastMessage()
                }
            }
            if mainViewModel.isADNotLoaded {
                showToast("광고 불러오는 중", status: $mainViewModel.isADNotLoaded) {
                    mainViewModel.closeToastMessage()
                }
            }
        }
        .alert(isPresented: $mainViewModel.needUpdate) {
            Alert(title: Text("업데이트"), message: Text("새 버전이 업데이트 되었습니다."), primaryButton: .default(Text("업데이트"), action: {
                mainViewModel.openAppStore()
            }), secondaryButton: .destructive(Text("나중에")))
        }
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            TitleView()
                .padding(.top, 35 * currentScreenRatio())
                .padding(.bottom, 8 * currentHeightRatio())
            HStack {
                SettingButtonView(isSettingPresented: $isSettingPresented)
                Spacer()
                GameCountView
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            AnswerBoardView()
            LifeView()
                .padding(.horizontal, 20)
                .padding([.top], 8)
                .padding([.bottom], 25)
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
            mainViewModel.closeToastMessage()
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
