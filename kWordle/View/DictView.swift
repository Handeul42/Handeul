//
//  DictView.swift
//  한들
//
//  Created by 강희영 on 2022/04/22.
//

import SwiftUI
import Firebase

struct DictView: View {
    @EnvironmentObject var viewModel: MainViewModel
    let width: CGFloat = uiSize.width - 70
    @State var answer: String = ""
    @State var meaning: String = ""
    @State var nowDate: Date = Date()
    @AppStorage("isColorWeakModeOn") var isColorWeakModeOn: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    @State var currentDate: Date = Date()
    var title = "share"
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    HStack {
                        Text(answer)
                            .font(.custom("EBSHMJESaeronR", fixedSize: 28))
                        Spacer()
                        Button {
                            actionSheet()
                        } label: {
                            copyButton()
                        }
                    }
                    HStack {
                        dictMeaning()
                        Spacer()
                    }
                }
                HStack(spacing: 24) {
                    Button {
                        withAnimation {
                            tapStartNewGameButton()
                        }
                    } label: {
                        newGameButtonWithAD()
                    }
                }
            }
            .onAppear {
                initDict()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    initDict()
                }
            }
            .padding(.horizontal, 35)
        }
    }
    
    private func initDict() {
        _ = viewModel.game.wordDict.map { wordDict in
            if wordDict.jamo == viewModel.game.answer {
                self.answer = wordDict.word
                self.meaning = wordDict.meaning
            }
        }
    }
    
    private func dictMeaning() -> some View {
        return Text(meaning)
            .font(.custom("EBSHMJESaeronL", fixedSize: 15))
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .truncationMode(.tail)
            .frame(minHeight: 35)
    }
    
    @ViewBuilder
    private func copyButton() -> some View {
        ZStack {
            HStack(spacing: 2) {
                Text("공유")
                    .foregroundColor(.hBlack)
                    .font(.custom("EBSHMJESaeronR", fixedSize: 15))
                    .padding([.top, .leading, .bottom], 8)
                Image("shareImage")
                    .padding([.top, .trailing, .bottom], 8)
            }
            .frame(width: 60, height: 28)
            .background(Color.hLigthGray.cornerRadius(5))
        }
    }

    private func newGameButtonWithAD() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 132, height: 50)
                .foregroundColor(.hLigthGray)
            Text("새문제 받기")
                .foregroundColor(.hBlack)
                .font(.custom("EBSHMJESaeronR", fixedSize: 17))
                .offset(x: 0, y: viewModel.life == 0 ? 2 : 0)
            if viewModel.life == 0 {
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
    
    func actionSheet() {
        let stringShare = viewModel.generateString()
        let activityVC = UIActivityViewController(activityItems: [stringShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func tapStartNewGameButton() {
            viewModel.useLifeCount()
    }
}
