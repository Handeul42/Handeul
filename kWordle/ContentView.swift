//
//  ContentView.swift
//  kWordle
//
//  Created by 강희영 on 2022/03/25.
//

import SwiftUI

struct ContentView: View {
    var arrayRow1: [String] = ["ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅛ", "ㅕ", "ㅑ"]
    var arrayRow2: [String] = ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅗ", "ㅓ", "ㅏ", "ㅣ"]
    var arrayRow3: [String] = ["ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ"]
    @State var currentRes: String = "abcd"
    var body: some View {
        VStack {
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
