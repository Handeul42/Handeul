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
                .foregroundColor(getColor(of: .black))
                .font(.custom("EBSHMJESaeronSB", fixedSize: 18))
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
                .foregroundColor(getColor(of: .black))
                .font(.custom("EBSHMJESaeronSB", fixedSize: 18))
        }
    }
    
    private func submitKeyInput(_ character: String) {
        HapticsManager.shared.playSound(id: 1123) // Press Click
        viewModel.appendReceivedCharacter(of: character)
    }
    
    var body: some View {
        ZStack {
            Color.hWhite
            VStack {
                HStack {
                    ForEach(viewModel.game.keyBoard.firstRow, id: \.self) { btn in
                        Button {
                            withAnimation {
                                submitKeyInput(btn.character)
                            }
                        } label: {
                            keyboardButton(btn)
                        }
                    }
                    .padding([.horizontal], widthPadding)
                    Button {
                        HapticsManager.shared.playSound(id: 1155) // Press Delete
                        if viewModel.game.currentColumn == 0 {
                            HapticsManager.shared.notification(type: .warning)
                        } else {
                            withAnimation {
                                viewModel.deleteOneCharacter()
                            }
                        }
                    } label: {
                        keyboardDeleteButton()
                    }
                    .padding([.horizontal], widthPadding)
                }
                HStack {
                    ForEach(viewModel.game.keyBoard.secondRow, id: \.self) { btn in
                        Button {
                            withAnimation {
                                submitKeyInput(btn.character)
                            }
                        } label: {
                            keyboardButton(btn)
                        }
                    }
                    .padding([.horizontal], widthPadding)
                }
                HStack {
                    ForEach(viewModel.game.keyBoard.thirdRow, id: \.self) { btn in
                        Button {
                            withAnimation {
                                submitKeyInput(btn.character)
                            }
                        } label: {
                            keyboardButton(btn)
                        }
                    }
                    .padding([.horizontal], widthPadding)
                    Button {
                        HapticsManager.shared.playSound(id: 1156) // Press Enter
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
    }
    
    func keyboardButton(_ key: Key) -> some View {
        let jaum: String = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ"
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
                .foregroundColor(getColor(of: key.status))
            Text(key.character)
                .foregroundColor(getColor(of: .black))
                .font(.custom("EBSHMJESaeronR", fixedSize: jaum.contains(key.character) ? 24 : 26))
        }
    }
}
