//
//  MainView+InvalidWordWarning.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/20.
//

import SwiftUI

struct InvalidWordWarning: View {
    var body: some View {
        Text("유효하지 않은 단어입니다.")
            .font(.custom("EBSHMJESaeronR", size: 22))
            .padding()
            .background(Color.red)
    }
}

struct InvalidWordWarning_Previews: PreviewProvider {
    static var previews: some View {
        InvalidWordWarning()
    }
}
