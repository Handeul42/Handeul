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
            .font(.custom("EBSHMJESaeronR", size: 16))
            .foregroundColor(Color.black)
            .padding()
            .background(Color.hWhite
                .opacity(0.95)
                .cornerRadius(8)
            )
    }
}

struct InvalidWordWarning_Previews: PreviewProvider {
    static var previews: some View {
        InvalidWordWarning()
    }
}
