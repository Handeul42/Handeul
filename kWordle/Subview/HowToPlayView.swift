//
//  HowToPlayView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var isHowToPlayPresented: Bool
    @State var pageIndex = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        self.isHowToPlayPresented = false
                    }
                }
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                isHowToPlayPresented = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .padding(24)
                                .foregroundColor(.hBlack)
                        }
                    }
                    Text("풀이 방법")
                        .font(.custom("EBSHMJESaeronR", size: 22))
                        .padding(24)
                }
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
            }.background(Color.hLigthGray.opacity(1).cornerRadius(10))
                .frame(width: 320, height: 420, alignment: .top)
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
        }
    }
    
    func getImage(of name: String) -> Image {
        if UserDefaults.standard.bool(forKey: "isColorWeakModeOn") {
            return Image(name + "CW")
        }
        return Image(name)
    }
}
