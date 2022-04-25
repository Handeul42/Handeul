//
//  Keyboard.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    
    private let buttonSize: CGSize = CGSize(width: Double(uiSize.width - 88) / 9.44, height: Double(uiSize.width - 88) / 9.44 / 8 * 11)
    private let extraButtonSize: CGSize = CGSize(width: Double(uiSize.width - 88) / 9.44 * 1.44, height: Double(uiSize.width - 88) / 9.44 / 8 * 11)
    private let widthPadding: Double = -1.5
    
    private func keyboardEnterButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(
                    width: extraButtonSize.width,
                    height: extraButtonSize.height)
                .foregroundColor(.hLigthGray)
            Text("제출")
                .foregroundColor(.black)
                .font(.custom("EBSHMJESaeronSB", size: 18))
        }
    }
    private func keyboardDeleteButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(
                    width: extraButtonSize.width,
                    height: extraButtonSize.height)
                .foregroundColor(.hLigthGray)
            Text("지움")
                .foregroundColor(.black)
                .font(.custom("EBSHMJESaeronSB", size: 18))
        }
    }
    
    private func submitKeyInput(_ character: String) {
        viewModel.appendReceivedCharacter(of: character)
    }
    var body: some View {
        VStack {
            HStack {
                ForEach(viewModel.game.keyBoard.firstRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                .padding([.horizontal], widthPadding)
                Button {
                    viewModel.deleteOneCharacter()
                } label: {
                    keyboardDeleteButton()
                }
                .padding([.horizontal], widthPadding)
            }
            HStack {
                ForEach(viewModel.game.keyBoard.secondRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                .padding([.horizontal], widthPadding)
            }
            HStack {
                ForEach(viewModel.game.keyBoard.thirdRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                .padding([.horizontal], widthPadding)
                Button {
                    withAnimation {
                        viewModel.submitAnswer()
                    }
                } label: {
                    keyboardEnterButton()
                }
                .padding([.horizontal], widthPadding)
            }
        }
    }
    
    func keyboardButton(_ key: Key) -> some View {
        let jaum: String = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ"
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
                .foregroundColor(getColor(of: key.status))
            Text(key.character)
                .foregroundColor(.black)
                .font(.custom("EBSHMJESaeronR", size: jaum.contains(key.character) ? 24 : 26))
        }
    }
}

func getColor(of status: Status) -> Color {
    switch status {
    case .gray:
        return Color.hGray
    case .lightGray:
        return Color.hLigthGray
    case .green:
        return Color.hGreen
    case .yellow:
        return Color.hOrange
    case .red:
        return Color.hRed
    case .white:
        return Color.white
    }
}
