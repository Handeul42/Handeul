//
//  HintView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/09.
//

import SwiftUI

struct HintView: View {
    
    @Binding var isHintPresented: Bool
    @Binding var isHintRevealed: Bool
    
    let hintRow: [Key]
    let handleHintSelection: ((Int) -> Void)?
    
    let hintRowScaleFactor: Double = 0.75
    
    init(isHintPresented: Binding<Bool>,
         isHintRevealed: Binding<Bool>,
         hintRow: [Key],
         handleHintSelection: ((Int) -> Void)? = nil) {
        _isHintPresented = isHintPresented
        _isHintRevealed = isHintRevealed
        self.hintRow = hintRow
        self.handleHintSelection = handleHintSelection
    }
    
    var body: some View {
        ZStack {
            hintBackground
            VStack {
                adMark
                Text("도움")
                    .font(.custom("EBSHMJESaeronR", size: 22))
                if isHintRevealed {
                    revealedHint
                } else {
                    hintSelection
                }
            }.frame(maxWidth: 320)
                .background(Color.hLigthGray.cornerRadius(10))
                .opacity(0.9)
        }
    }
    
    var adMark: some View {
        HStack {
            Text("광고")
                .font(.custom("EBSHMJESaeronR", size: 20))
                .padding(4)
                .background(Color.hRed.cornerRadius(8, corners: [.topLeft, .bottomRight]))
                .foregroundColor(.hWhite)
            Spacer()
        }
    }
    
    var revealedHint: some View {
        VStack {
            VStack(spacing: 3) {
                Horline(height: 3)
                AnswerBoardRow(row: self.hintRow)
                Horline(height: 3)
            }.scaleEffect(hintRowScaleFactor, anchor: .center)
            Button {
                withAnimation {
                    isHintPresented = false
                }
            } label: {
                Text("확인")
                    .font(.custom("EBSHMJESaeronR", size: 16))
                    .foregroundColor(.hBlack)
                    .padding(8)
                    .background(Color.hGray.cornerRadius(5))
            }.padding(.bottom, 24)
                .padding(.top, 8)
        }
        
    }
    
    var hintSelection: some View {
        VStack(spacing: 0) {
            hintAnswerBoardRow
                .scaleEffect(hintRowScaleFactor, anchor: .center)
                .padding(8)
            Text("도움이 필요한 칸을 눌러주세요!")
                .font(.custom("EBSHunminjeongeumSB", size: 14))
                .padding(.bottom, 24)
        }
    }
    
    var hintAnswerBoardRow: some View {
        VStack(spacing: -2) {
            Horline(height: 3)
                .padding([.bottom], 5)
            Horline(height: 2)
            HStack {
                ForEach(hintRow.indices, id: \.self) { idx in
                    AnswerBoardBlock(key: hintRow[idx], blockSize: keyButtonWidth)
                        .onTapGesture {
                            handleHintSelection?(idx)
                        }
                }.padding([.horizontal], -5)
            }
            Horline(height: 2)
                .padding([.bottom], 5)
            Horline(height: 3)
        }
    }
    
    var hintBackground: some View {
        Color.black.ignoresSafeArea()
            .opacity(0.5)
            .onTapGesture {
                if !isHintRevealed {
                    withAnimation {
                        isHintPresented = false
                    }
                }
            }
    }
}

struct HintView_Previews: PreviewProvider {
    
    static var previews: some View {
        HintView(isHintPresented: .constant(true), isHintRevealed: .constant(false), hintRow: [Key](repeating: Key(id: UUID(), character: "", status: .lightGray), count: 5))
    }
}
