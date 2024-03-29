//
//  StatisticsView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

struct StatisticsView: View {
    
    @Binding var isStatisticsPresented: Bool
    let statistics = Statistics()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        isStatisticsPresented = false
                    }
                }
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                isStatisticsPresented = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .padding(24)
                                .foregroundColor(.hBlack)
                        }
                    }
                    Text("통계")
                        .font(.custom("EBSHMJESaeronR", fixedSize: 22))
                        .padding(24)
                }
                
                if statistics.totalPlayed == 0 {
                    dataUnavailable
                } else {
                    statBoard
                        .padding(.bottom, 24)
                    barGraph
                }
            }
            .frame(width: 320, height: 420, alignment: .top)
            .background(Color.hLigthGray.cornerRadius(10))

        }
    }
    
    private var dataUnavailable: some View {
        VStack {
            Spacer()
            Text("데이터가 없습니다.")
                .font(.custom("EBSHMJESaeronR", fixedSize: 22))
            Spacer()
        }
    }
    
    private var barGraph: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(statistics.playerTryForWin.indices, id: \.self) { idx in
                HStack(spacing: 12) {
                    Text("\(idx + 1)")
                        .font(.system(size: 20))
                        .frame(width: 20, height: 20, alignment: .leading)
                    HStack {
                        Spacer()
                            .frame(width: barLength(of: idx), height: nil)
                        Text("\(statistics.playerTryForWin[idx])")
                            .foregroundColor(.hWhite)
                            .padding(4)
                    }.background(Color.hRed)
                }
            }
        }
    }
    
    private var statBoard: some View {
        HStack(spacing: 16) {
            showStat(of: "푼 문제", number: "\(statistics.totalPlayed)")
            showStat(of: "정답률", number: String(format: "%.1f", statistics.winRatio) + "%")
            showStat(of: "현재 연승", number: "\(statistics.currentWinStreak)")
            showStat(of: "최다 연승", number: "\(statistics.maxWinStreak)")
        }
    }
    
    private func barLength(of idx: Int) -> CGFloat {
        if statistics.getTryRatio(idx) == 0 {
            return 1
        }
        return 190 * statistics.getTryRatio(idx)
    }
    
    private func showStat(of label: LocalizedStringKey, number: String) -> some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.system(size: 16))
            Text(label)
                .font(.custom("EBSHMJESaeronL", fixedSize: 16))
                .multilineTextAlignment(.center)
        }
    }
}
