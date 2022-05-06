//
//  HowToPlayOnFirstLaunch.swift
//  한들
//
//  Created by JaemooJung on 2022/05/06.
//

import SwiftUI

struct HowToPlayOnFirstLaunch: View {
    @Binding var isHowToPlayPresented: Bool
    let howToPlayTextMain: String = "무작위 단어를 6번 안에 맞춰보세요.\n제출 후에 변화하는 글자의 바탕색으로\n정답을 유추할 수 있습니다."
    let howToPlayTextExampleCorrect = "ㅍ은 단어에 포함되며 위치도 맞습니다."
    let howToPlayTextExampleDup1 = "첫 번째 ㄱ은 단어에 포함되며 위치도 맞습니다."
    let howToPlayTextExampleDup2 = "두 번째 ㄱ은 단어에 포함되나 다른 위치에 있습니다."
    let howToPlayTextExampleWrong = "ㅇ은 단어에 포함되지 않습니다."
    let howToPlayTextValid = "유효한 단어만 제출 가능합니다.\n이중 모음과 된소리 자음(쌍자음)은\n풀어서 입력합니다."
    let howToPlayDipth = "\'기계\'의 ㅖ를 풀어 입력한 경우"
    let howToPlayDCons = "\'버찌\'의 ㅉ을 풀어 입력한 경우"
    @State var pageIndex = 0
    
    var body: some View {
        ZStack {
            Color.hLigthGray.ignoresSafeArea().opacity(0.98)
            VStack {
                TitleView().padding(24)
                Text("풀이 방법")
                    .font(.custom("EBSHMJESaeronR", size: 22))
                TabView {
                    VStack {
                        firstPage
                        Spacer()
                    }
                    VStack {
                        secondPage
                        Spacer()
                    }
                }.tabViewStyle(.page(indexDisplayMode: .always))
            }
                .frame(width: 320, height: 520, alignment: .top)
        }
    }
    
    var firstPage: some View {
        VStack {
            Text(howToPlayTextMain).font(.custom("EBSHMJESaeronL", size: 16))
            getImage(of: "howToPlayExCorrect")
            Text(howToPlayTextExampleCorrect)
                .font(.custom("EBSHMJESaeronL", size: 13))
            getImage(of: "howToPlayExDup")
            Text(howToPlayTextExampleDup1).font(.custom("EBSHMJESaeronL", size: 13))
            Text(howToPlayTextExampleDup2).font(.custom("EBSHMJESaeronL", size: 13))
            Image("howToPlayExWrong")
            Text(howToPlayTextExampleWrong).font(.custom("EBSHMJESaeronL", size: 13))
        }
    }
    
    var secondPage: some View {
        VStack {
            Text(howToPlayTextValid).font(.custom("EBSHMJESaeronL", size: 16))
            Image("howToPlayExDipth")
            Text(howToPlayDipth)
                .font(.custom("EBSHMJESaeronL", size: 13))
            Image("howToPlayExDoubleCons")
            Text(howToPlayDCons)
                .font(.custom("EBSHMJESaeronL", size: 13))
            Button {
                withAnimation {
                    self.isHowToPlayPresented = false
                }
            } label: {
                Text("시작하기")
                    .font(.custom("EBSHMJESaeronR", size: 20))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.hGreen)
                    .cornerRadius(8)
            }.padding(.top, 28)
        }
    }
    
    func getImage(of name: String) -> Image {
        if UserDefaults.standard.bool(forKey: "isColorWeakModeOn") {
            return Image(name + "CW")
        }
        return Image(name)
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
    }
}
