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
            }
        }
    }
    
    func keyboardButton(_ key: Key) -> some View {
        let keyButtonSize: CGSize = CGSize(width: 32, height: 44)
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: keyButtonSize.width,
                       height: keyButtonSize.height)
                .foregroundColor(getColor(of: key.status))
            Text(key.character)
                .foregroundColor(.black)
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

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
