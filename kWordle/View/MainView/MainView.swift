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
    @State var isHintPresented: Bool = false
        
    var body: some View {
        ZStack {
            mainView
                .onChange(of: scenePhase) { newScenePhase in
                    handleScenePhaseChange(newScenePhase)
                }
            if vm.isResultAnimationPlaying {
                resultAnimation
            }
            if isHintPresented {
                HintView(isHintPresented: $isHintPresented,
                         isHintRevealed: $vm.isHintRevealed,
                         hintRow: vm.hintRow,
                         currentHintCount: vm.CurrentHintCount,
                         handleHintSelection: vm.showHintWithAd
                ).onDisappear { vm.isHintRevealed = false }
                    .zIndex(1)
            }
            if isSettingPresented {
                SettingView(isSettingPresented: $isSettingPresented)
                    .zIndex(2)
                    .environmentObject(vm)
            }
            if shouldHowToPlayPresented {
                HowToPlayOnFirstLaunch(isHowToPlayPresented: $shouldHowToPlayPresented)
                    .zIndex(3)
            }
            if vm.isInvalidWordWarningPresented {
                ToastView(presentStatus: $vm.isInvalidWordWarningPresented, toastText: "유효하지 않은 단어입니다")
                    .zIndex(4)
            }
            if vm.isADNotLoaded {
                ToastView(presentStatus: $vm.isADNotLoaded, toastText: "광고 불러오는 중")
                    .zIndex(5)
            }
        }
    }
}

// MARK: Subviews
extension MainView {
    
    var mainView: some View {
        VStack(spacing: 0) {
            if screenHasSpaceForTitle {
                TitleView()
                    .padding(.top, 20 * currentScreenRatio())
                    .padding(.bottom, 8 * currentHeightRatio())
            }
            HeaderMenuBar()
            AnswerBoardView(answerBoard: vm.game.answerBoard,
                            currentColumn: vm.game.currentColumn,
                            currentRow: vm.game.currentRow)
            LifeView(showAds: vm.addLifeCountWithAD,
                     currentLifeCount: vm.lifeCount,
                     isGameFinished: vm.game.isGameFinished)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 25)
            if !vm.game.isGameFinished {
                KeyboardView()
            } else {
                GameResultView()
            }
            Spacer()
        }
        .environmentObject(vm)
        .onAppear {
            requestPermission()
            vm.closeToastMessage()
        }
    }
        
    private func HeaderMenuBar() -> some View {
        return HStack {
            SettingButtonView(isSettingPresented: $isSettingPresented)
            if !vm.game.isGameFinished {
                HintButton()
            }
            Spacer()
            GameNumberView(count: vm.game.gameNumber)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var newGameWithADButtonLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 132, height: 50)
                .foregroundColor(.hLigthGray)
            Text("새문제 받기")
                .foregroundColor(.hBlack)
                .font(.custom("EBSHMJESaeronR", fixedSize: 17))
                .offset(x: 0, y: vm.lifeCount == 0 ? 2 : 0)
            if vm.lifeCount == 0 {
                ZStack {
                    Rectangle()
                        .frame(width: 32, height: 13)
                        .foregroundColor(.hRed)
                    Text("광고")
                        .foregroundColor(.white)
                        .font(.custom("EBSHMJESaeronR", fixedSize: 14))
                }
                .offset(x: 42, y: -18)
            }
        }
    }
    
    private func HintButton() -> some View {
        return Button {
            withAnimation {
                self.isHintPresented = true
            }
        } label: {
            Image("hintWithAdIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .foregroundColor(.hBlack)
                .padding(.horizontal, 2)
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
    
    fileprivate func GameResultView() -> some View {
        return VStack(spacing: 0) {
            DictView(game: vm.game)
            Button {
                withAnimation {
                    vm.useLifeCount()
                }
            } label: {
                newGameWithADButtonLabel
                    .padding(16)
            }.disabled(!vm.game.isGameFinished)
        }
    }
}

// MARK: Utils
extension MainView {
    private var screenHasSpaceForTitle: Bool {
        return round(UIHeight/UIWidth * 10) > round(16/9 * 10)
    }
    
    private func handleScenePhaseChange(_ newScenePhase: ScenePhase) {
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
}
