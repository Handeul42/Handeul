//
//  HowToPlayView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var isHowToPlayPresented: Bool
    let howToPlayTextMain: String = "한글 워들을 6번 안에 맞춰보세요.\n제출 후에 변화하는 글자의 바탕색으로\n정답을 유추할 수 있습니다."
    let howToPlayTextExampleCorrect = "ㅁ은 단어에 포함되며 위치도 맞습니다."
    let howToPlayTextExampleDup1 = "첫 번째 ㄱ은 단어에 포함되며 위치도 맞습니다."
    let howToPlayTextExampleDup2 = "두 번째 ㄱ은 단어에 포함되나 다른 위치에 있습니다."
    let howToPlayTextExampleWrong = "ㅇ은 단어에 포함되지 않습니다."
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        self.isHowToPlayPresented.toggle()
                    }
                }
            VStack {
                Text("풀이 방법")
                    .font(.custom("EBSHMJESaeronR", size: 22))
                    .padding()
                VStack {
                    Text(howToPlayTextMain).font(.custom("EBSHMJESaeronL", size: 16))
                    Image("howToPlayExCorrect")
                    Text(howToPlayTextExampleCorrect)
                        .font(.custom("EBSHMJESaeronL", size: 13))
                        .padding(.bottom, 8)
                    Image("howToPlayExDup")
                    Text(howToPlayTextExampleDup1).font(.custom("EBSHMJESaeronL", size: 13))
                    Text(howToPlayTextExampleDup2).font(.custom("EBSHMJESaeronL", size: 13))
                        .padding(.bottom, 8)
                    Image("howToPlayExWrong")
                    Text(howToPlayTextExampleWrong).font(.custom("EBSHMJESaeronL", size: 13))
                }.padding([.leading, .trailing, .bottom])
            }.background(Color.hWhite.opacity(0.95).cornerRadius(8))
                .padding()
        }
    }
}

//struct HowToPlayView_Previews: PreviewProvider {
//    @State var isHowToPlayPresented: Bool = false
//    static var previews: some View {
//        HowToPlayView(isHowToPlayPresented: self.)
//    }
//}
