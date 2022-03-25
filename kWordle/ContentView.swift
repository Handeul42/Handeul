//
//  ContentView.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI

struct ContentView: View {
    var arrayRow0: [String] = ["ㅃ", "ㅉ", "ㄸ", "ㅆ"]
    var arrayRow01: [String] = ["ㅒ", "ㅖ"]
    var arrayRow1: [String] = ["ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅛ", "ㅕ", "ㅑ", "ㅐ", "ㅔ"]
    var arrayRow2: [String] = ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅗ", "ㅓ", "ㅏ", "ㅣ"]
    var arrayRow3: [String] = ["ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ"]
    
    @State var currentRes: String = "abcd"
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    ForEach(0..<6, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 50, height: 50)
                            .overlay {
                                Text(i < currentRes.count ? currentRes.map {String($0)}[i] : "")
                            }
                    }
                }
            }
            Spacer()
            Spacer()
            HStack {
                ForEach(arrayRow0, id: \.self) { char in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .overlay {
                            Text(char)
                        }
                }
                Rectangle()
                    .frame(width: 145, height: 30)
                    .foregroundColor(.white)
                ForEach(arrayRow01, id: \.self) { char in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .overlay {
                            Text(char)
                        }
                }
            }
            HStack {
                ForEach(arrayRow1, id: \.self) { char in
                    Button {
                        currentRes.append(char)
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                            .overlay {
                                Text(char)
                            }
                    }
                }
            }
            HStack {
                ForEach(arrayRow2, id: \.self) { char in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .overlay {
                            Text(char)
                        }
                }
            }
            HStack {
                ForEach(arrayRow3, id: \.self) { char in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .overlay {
                            Text(char)
                        }
                }
            }
            Button  {
                print("submit")
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 300, height: 30)
                    .foregroundColor(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 2)
                        Text("Submit")
                    }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

