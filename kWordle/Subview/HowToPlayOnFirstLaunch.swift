//
//  HowToPlayOnFirstLaunch.swift
//  한들
//
//  Created by JaemooJung on 2022/05/06.
//

import SwiftUI

struct HowToPlayOnFirstLaunch: View {
    @Binding var isHowToPlayPresented: Bool
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
