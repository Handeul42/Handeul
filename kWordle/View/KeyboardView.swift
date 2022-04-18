//
//  Keyboard.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    private func keyboardEnterButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: keyboardWidth * 2, height: keyboardHeight)
                .foregroundColor(.gray)
            Text("Enter")
                .foregroundColor(.black)
        }
    }
    private func keyboardDeleteButton() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: keyboardWidth * 1.5, height: keyboardHeight)
                .foregroundColor(.gray)
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        }
    }
    private func submitKeyInput(_ character: String) {
        viewModel.appendReceivedCharacter(of: character)
    }
    var body: some View {
        VStack {
            HStack {
                ForEach(viewModel.keyboardViewModel.firstRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                Button {
                    viewModel.deleteOneCharacter()
                } label: {
                    keyboardDeleteButton()
                }
            }
            HStack {
                ForEach(viewModel.keyboardViewModel.secondRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
            }
            HStack {
                ForEach(viewModel.keyboardViewModel.thirdRow, id: \.self) { btn in
                    Button {
                        submitKeyInput(btn.character)
                    } label: {
                        keyboardButton(btn)
                    }
                }
                Button {
                    viewModel.submitAnswer()
                } label: {
                    keyboardEnterButton()
                }

            }
        }
    }
}

func keyboardButton(_ key: Key) -> some View {
    return ZStack {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: keyboardWidth, height: keyboardHeight)
            .foregroundColor(getColor(of: key.status))
        Text(key.character)
            .foregroundColor(.white)
    }
}

func getColor(of status: Status) -> Color {
    switch status {
    case .gray:
        return Color.gray
    case .lightGray:
        return Color.white
    case .green:
        return Color.green
    case .yellow:
        return Color.yellow
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
