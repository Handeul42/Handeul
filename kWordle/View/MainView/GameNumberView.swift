//
//  GameNumberView.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/07.
//

import SwiftUI

struct GameNumberView: View {
    
    let count: Int
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text("No.")
                .font(.system(size: 18))
            ZStack {
                Text("\(count)")
                    .font(.system(size: 28))
                Rectangle()
                    .frame(width: 56, height: 2)
                    .offset(y: 16)
            }
            .frame(width: 56, height: 32)
        }
        .foregroundColor(.hRed)
    }
}

struct GameCountView_Previews: PreviewProvider {
    static var previews: some View {
        GameNumberView(count: 1)
    }
}
