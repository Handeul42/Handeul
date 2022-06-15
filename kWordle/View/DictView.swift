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
    
    @State var currentDate: Date = Date()
    var title = "share"
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    HStack {
                        Text(answer)
                            .font(.custom("EBSHMJESaeronR", fixedSize: 28))
                        currentWinStreakMarker()
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
                HStack {
                    Button {
//                        viewModel.startNewGame()
                    } label: {
                        todayGameButton()
                    }
                    .disabled(true)
                    Spacer()
                    Button {
                        viewModel.startNewGame()
                    } label: {
                        newGameButtonWithAD()
                    }
                }
            }
            .onAppear {
                initDict()
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
    
    @ViewBuilder
    private func currentWinStreakMarker() -> some View {
        let currentWinStreak = Statistics().currentWinStreak
        HStack(alignment: .bottom, spacing: 0) {
            if currentWinStreak > 0 {
                Text("\(currentWinStreak)")
                    .font(.system(size: 12))
                    .padding([.top, .bottom, .leading], 6)
                Text("연승!")
                    .font(.custom("EBSHMJESaeronR", fixedSize: 12))
                    .padding([.top, .bottom, .trailing], 6)
            } else {
                Text("연승 끝... 😢")
                    .font(.custom("EBSHMJESaeronR", fixedSize: 12))
                    .padding(6)
            }
        }.foregroundColor(.white)
            .background((currentWinStreak != 0 ? (isColorWeakModeOn ? Color.hSkyblue : Color.hGreen) : Color.hRed).cornerRadius(5))
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
            HStack {
                Text("공유")
                    .foregroundColor(.hBlack)
                    .font(.custom("EBSHMJESaeronR", fixedSize: 17))
                    .padding([.top, .leading, .bottom], 8)
                Image(systemName: "arrowshape.turn.up.left")
                    .resizable()
                    .frame(width: 19, height: 15)
                    .foregroundColor(.hBlack)
                    .padding([.top, .trailing, .bottom], 8)
            }
            .background(Color.hLigthGray.cornerRadius(5))
        }
    }
    
    private func todayGameButton() -> some View {
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
                    .foregroundColor(.hBlack)
                    .font(.custom("EBSHMJESaeronR", size: 17))
                Text(countDownString(from: Date() + 1))
                    .foregroundColor(.hBlack)
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
                .foregroundColor(.hBlack)
                .font(.custom("EBSHMJESaeronR", fixedSize: 17))
            ZStack {
                Rectangle()
                    .frame(width: 32, height: 16)
                    .foregroundColor(.hRed)
                Text("광고")
                    .foregroundColor(.white)
                    .font(.custom("EBSHMJESaeronR", fixedSize: 14))
            }
            .offset(x: 44, y: -22)
        }
    }
    
    func actionSheet() {
        let stringShare = viewModel.generateString()
        let activityVC = UIActivityViewController(activityItems: [stringShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
