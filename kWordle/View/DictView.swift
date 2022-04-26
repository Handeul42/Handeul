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
    @State var isCopied: Bool = false
    @State var nowDate: Date = Date()
    
    @State var currentDate: Date = Date()
    var title = "share"
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(answer)
                        .font(.custom("EBSHMJESaeronR", size: 28))
                    Spacer()
                    Button {
                        UIPasteboard.general.string = viewModel.generateString()
                        isCopied = true
                        Analytics.logEvent(AnalyticsEventShare, parameters: ["answer": viewModel.game.answer])
                    } label: {
                        copyButton()
                    }
                }
                HStack {
                    dictMeaning()
                    Spacer()
                }
                HStack {
                    Button {
                        viewModel.startNewGame()
                    } label: {
                        newGameButton()
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.startNewGame()
                        }
                    } label: {
                        newGameButtonWithAD()
                    }
                }
            }
            .onAppear {
                initDict()
            }
            .padding(.horizontal, 35)
            
            if isCopied {
                showToast("복사되었습니다.") {
                    isCopied.toggle()
                }
            }
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
            .font(.custom("EBSHMJESaeronL", size: 15))
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .truncationMode(.tail)
            .frame(minHeight: 50)
    }
    
    private func copyButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 72, height: 36)
                .foregroundColor(.hLigthGray)
            HStack {
                Text("공유")
                    .foregroundColor(.black)
                    .font(.custom("EBSHMJESaeronR", size: 17))
                Image(systemName: "arrowshape.turn.up.left")
                    .resizable()
                    .frame(width: 19, height: 15)
                    .foregroundColor(.black)
            }
        }
    }
    
    private func newGameButton() -> some View {
        var timer: Timer {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.nowDate = Date()
            }
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 132, height: 61)
                .foregroundColor(.hLigthGray)
            VStack {
                Text("내일의 문제")
                    .foregroundColor(.black)
                    .font(.custom("EBSHMJESaeronR", size: 17))
                Text(countDownString(from: Date() + 1))
                    .foregroundColor(.black)
                    .onAppear {
                        _ = timer
                    }
            }
        }
    }
    
    private func countDownString(from date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let midnight = calendar.startOfDay(for: nowDate)
        let referenceDate: Date = calendar.date(byAdding: .day, value: 1, to: midnight)!
        let components = calendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: nowDate,
                            to: referenceDate)
        return String(format: "%02d:%02d:%02d",
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }

    private func newGameButtonWithAD() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 132, height: 61)
                .foregroundColor(.hLigthGray)
            Text("새문제 받기")
                .foregroundColor(.black)
                .font(.custom("EBSHMJESaeronR", size: 17))
            ZStack {
                Rectangle()
                    .frame(width: 32, height: 16)
                    .foregroundColor(.hRed)
                Text("광고")
                    .foregroundColor(.white)
                    .font(.custom("EBSHMJESaeronR", size: 14))
            }
            .offset(x: 44, y: -22)
        }
    }
}
