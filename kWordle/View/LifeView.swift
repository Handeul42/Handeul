//
//  LifeView.swift
//  한들
//
//  Created by Heeyoung Kang on 2023/02/17.
//

import SwiftUI

struct LifeView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    var lifeCount: Int {
        return mainViewModel.lifeCount
    }
    let totalLifeCount: Int = 5
    @State var lifeTouch: Bool = false
    @State var plusTouch: Bool = false
    @State private var currentTime = Date()
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date() // 현재 시간을 업데이트합니다.
        }
    }
    
    var body: some View {
        HStack (spacing: 0) {
            HStack (spacing: 4) {
                ForEach(0..<lifeCount, id: \.self) { _ in
                    Image("LifeImage")
                        .resizable()
                        .frame(width: 20, height: 30)
                }
                if totalLifeCount - lifeCount > 0 {
                    ForEach(0..<totalLifeCount - lifeCount, id: \.self) { _ in
                        Image("emptyLifeImage")
                            .resizable()
                            .frame(width: 20, height: 30)
                    }                                 
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    lifeTouch.toggle()
                }
            }
            if lifeCount < 5 {
                Button {
                    withAnimation {
                        plusTouch.toggle()
                        lifeTouch = false
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.hBlack)
                }
                .padding(.horizontal, 4)
                ZStack {
                    if plusTouch {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.hLigthGray)
                                .frame(width: 117, height: 31)
                                .cornerRadius(5)
                            HStack (spacing: 4) {
                                Text("광고로 충전")
                                    .font(.custom("EBSHMJESaeronR", fixedSize: 16))
                                Image("youtube")
                            }
                        }
                        .onTapGesture {
                            print("loading ads")
                            print(mainViewModel.game.answer)
                            mainViewModel.showAds()
                        }
                    }
                    if lifeTouch {
                        leftTimeCounter()
                    }
                }
            }
            Spacer(minLength: 5)
            currentWinStreakMarker()
        }
        .frame(height: 31)
        .onAppear {
            _ = timer
        }
    }
    
    @ViewBuilder
    private func currentWinStreakMarker() -> some View {
        let currentWinStreak = Statistics().currentWinStreak
        if mainViewModel.game.isGameFinished || currentWinStreak > 0 {
            ZStack {
                Rectangle()
                    .frame(width: 80, height: 28)
                    .border(Color.hBlack, width: 1)
                    .foregroundColor(mainViewModel.game.isGameFinished ? .hGreen : .hSkyblue)
                HStack(alignment: .bottom, spacing: 0) {
                    if currentWinStreak > 0 {
                        Text("\(currentWinStreak) ")
                            .font(.system(size: 14))
                            .padding([.top, .bottom, .leading], 6)
                        Text(mainViewModel.game.isGameFinished ? "연승!" : "연승중")
                            .font(.custom("EBSHMJESaeronR", fixedSize: 14))
                            .padding([.top, .bottom, .trailing], 6)
                    } else {
                        ZStack {
                            Rectangle()
                                .frame(width: 80, height: 28)
                                .border(Color.hRed, width: 1)
                                .foregroundColor(.hWhite)
                            Text("연승끝🤯")
                                .font(.custom("EBSHMJESaeronR", fixedSize: 14))
                                .padding(6)
                        }
                    }
                }.foregroundColor(.hBlack)
            }
        }
    }
    
    func leftTimeCounter() -> some View {
        return ZStack {
            Rectangle()
                .frame(width: 117, height: 31)
                .cornerRadius(5)
                .foregroundColor(.hGray)
            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [3]))
                .frame(width: 117, height: 31)
                .cornerRadius(5)
                .foregroundColor(.hBlack)
            Text("충전까지 \(countDownString())")
                .font(.custom("EBSHMJESaeronR", fixedSize: 13))
        }
        .onTapGesture {
            withAnimation {
                lifeTouch = false
            }
        }
        .onAppear {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    lifeTouch = false
                }
            }
        }
    }
    
    private func countDownString() -> String {
        var timeStamp = ""
        if let lifeTimeStamp = UserDefaults.standard.string(forKey: "lifeTimeStamp"), !lifeTimeStamp.isEmpty {
            let lastDate = mainViewModel.stringToDate(with: lifeTimeStamp) + 3600
            let diffInHours = lastDate.timeIntervalSince(currentTime)
            print("\(diffInHours)")
            
            let min = floor(diffInHours / 60)
            let sec = diffInHours.truncatingRemainder(dividingBy: 60)
            
            timeStamp = String(format: "%02.0f:%02.0f", min, sec)
        }
        return timeStamp
    }
}
