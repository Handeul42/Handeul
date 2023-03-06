//
//  MainView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var vm: MainViewModel = MainViewModel()
    @AppStorage("shouldHowToPlayPresented") var shouldHowToPlayPresented: Bool = true
    @State var isSettingPresented: Bool = false
    
    var body: some View {
        ZStack {
            mainView
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .inactive {
                        if !vm.game.isGameFinished {
                            vm.game.saveCurrentGame()
                        }
                    } else if newScenePhase == .active {
                        withAnimation {
                            _ = vm.refreshGameOnActive()
                        }
                    }
                    vm.closeToastMessage()
                }
            if vm.isResultAnimationPlaying {
                resultAnimation
            }
            if isSettingPresented {
                SettingView(isSettingPresented: $isSettingPresented)
                    .zIndex(1)
                    .environmentObject(vm)
            }
            if shouldHowToPlayPresented {
                HowToPlayOnFirstLaunch(isHowToPlayPresented: $shouldHowToPlayPresented)
                    .zIndex(2)
            }
            if vm.isInvalidWordWarningPresented {
                showToast("유효하지 않은 단어입니다.", status: $vm.isInvalidWordWarningPresented) {
                    vm.closeToastMessage()
                }
            }
            if vm.isADNotLoaded {
                showToast("광고 불러오는 중", status: $vm.isADNotLoaded) {
                    vm.closeToastMessage()
                }
            }
        }
        .alert(isPresented: $vm.needUpdate) {
            Alert(title: Text("업데이트"), message: Text("새 버전이 업데이트 되었습니다."), primaryButton: .default(Text("업데이트"), action: {
                vm.openAppStore()
            }), secondaryButton: .destructive(Text("나중에")))
        }
    }
    
    private var mainView: some View {
        VStack(spacing: 0) {
            if screenHasSpaceForTitle {
                TitleView()
                    .padding(.top, 35 * currentScreenRatio())
                    .padding(.bottom, 8 * currentHeightRatio())
            }
            HStack {
                SettingButtonView(isSettingPresented: $isSettingPresented)
                Spacer()
                GameCountView
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            AnswerBoardView(answerBoard: vm.game.answerBoard,
                            currentColumn: vm.game.currentColumn,
                            currentRow: vm.game.currentRow)
            LifeView()
                .padding(.horizontal, 20)
                .padding([.top], 8)
                .padding([.bottom], 25)
            if !vm.game.isGameFinished {
                KeyboardView()
            } else {
                DictView()
                    .disabled(!vm.game.isGameFinished)
            }
            Spacer()
        }
        .environmentObject(vm)
        .onAppear {
            requestPermission()
            vm.closeToastMessage()
        }
    }
    
    private var resultAnimation: some View {
        var filename: String = ""
        if vm.game.didPlayerWin {
            filename = UserDefaults.standard.bool(forKey: "isColorWeakModeOn") ? "win_color_weak" : "win"
        } else {
            filename = "lose"
        }
        return (
            LottieView(filename, animationSpeed: 2, isPlayed: $vm.isResultAnimationPlaying)
                .shadow(radius: 8)
                .zIndex(1)
        )
    }
    
    private var GameCountView: some View {
        HStack(alignment: .bottom) {
            Text("No.")
                .font(.system(size: 18))
            ZStack {
                Text("\(vm.game.gameNumber)")
                    .font(.system(size: 28))
                Rectangle()
                    .frame(width: 56, height: 2)
                    .offset(y: 16)
            }
            .frame(width: 56, height: 32)
        }
        .foregroundColor(.hRed)
    }
    
    private var screenHasSpaceForTitle: Bool {
        return round(UIHeight/UIWidth * 10) > round(16/9 * 10)
    }
}
