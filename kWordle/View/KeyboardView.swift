//
//  Keyboard.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var keyboardViewModel: KeyboardViewModel
    @EnvironmentObject var viewModel: MainViewModel
    
    private let enterButtonSize: CGSize = CGSize(width: 46, height: 44)
    private let backButtonSize: CGSize = CGSize(width: 46, height: 44)
    private let widthPadding: Double = -1.5
    
    private func keyboardEnterButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(
                    width: enterButtonSize.width,
                    height: enterButtonSize.height)
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
                    width: backButtonSize.width,
                    height: backButtonSize.height)
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
                ForEach(keyboardViewModel.firstRow, id: \.self) { btn in
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
                ForEach(keyboardViewModel.secondRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                .padding([.horizontal], widthPadding)
            }
            HStack {
                ForEach(keyboardViewModel.thirdRow, id: \.self) { btn in
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
                Button {
                    UIPasteboard.general.string = generateString()
                } label: {
                    Text("결과 공유")
                }

            }
        }
    }
    
    func generateString() -> String {
        var ret: String = ""
        
        for row in viewModel.rows {
            for char in row {
                switch char.status {
                case .gray :
                    ret += "⬜️"
                case .green :
                    ret += "🟩"
                case .yellow :
                    ret += "🟧"
                case .white, .red, .lightGray:
                    break
                }
            }
            ret += "\n"
        }
        return "한들\n앱주소\n" + ret.trimmingCharacters(in: .newlines)
    }
    
    func keyboardButton(_ key: Key) -> some View {
        let keyButtonSize: CGSize = CGSize(width: 32, height: 44)
        let jaum: String = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ"
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: keyButtonSize.width,
                       height: keyButtonSize.height)
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
