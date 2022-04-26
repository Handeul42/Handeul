//
//  StatisticsView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

struct StatisticsView: View {
    
    @Binding var isStatisticsPresented: Bool
    var vm = StatisticsViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        isStatisticsPresented.toggle()
                    }
                }
            VStack(spacing: 0) {
                Text("통계")
                    .font(.custom("EBSHMJESaeronR", size: 22))
                    .padding(20)

                if vm.statistics.totalPlayed == 0 {
                    dataUnavailable
                } else {
                    statBoard
                        .padding(10)
                    barGraph
                        .padding(30)
                }
            }
            .padding()
            .background(Color.hLigthGray.cornerRadius(8))
        }
    }
    
    private var dataUnavailable: some View {
        Text("데이터가 없습니다.")
            .font(.custom("EBSHMJESaeronR", size: 22))
            .padding(30)
    }
    
    private var barGraph: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(vm.statistics.playerTryForWin.indices, id: \.self) { idx in
                HStack(spacing: 12) {
                    Text("\(idx + 1)")
                        .font(.system(size: 20))
                        .frame(width: 20, height: 20, alignment: .leading)
                    HStack {
                        Spacer()
                            .frame(width: barLength(of: idx), height: nil)
                        Text("\(vm.statistics.playerTryForWin[idx])")
                            .foregroundColor(.hWhite)
                            .padding(6)
                    }.background(Color.hRed)
                }
            }
        }
    }
    
    private var statBoard: some View {
        HStack {
            showStat(of: "푼 문제", number: "\(vm.statistics.totalPlayed)")
            showStat(of: "정답률", number: String(format: "%.1f", vm.statistics.winRatio) + "%")
            showStat(of: "현재 연승", number: "\(vm.statistics.currentWinStreak)")
            showStat(of: "최다 연승", number: "\(vm.statistics.maxWinStreak)")
        }
    }
    
    private func barLength(of idx: Int) -> CGFloat {
        if vm.statistics.getTryRatio(idx) == 0 {
            return 1
        }
        return uiSize.width * 0.55 * vm.statistics.getTryRatio(idx)
    }
    
    private func showStat(of label: String, number: String) -> some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.custom("EBSHMJESaeronR", size: 24))
            Text(label)
                .font(.custom("EBSHMJESaeronL", size: 16))
        }
    }
}
