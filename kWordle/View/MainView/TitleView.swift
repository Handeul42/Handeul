//
//  TitleView.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/19.
//

import SwiftUI

struct TitleView: View {
    @Environment(\.layout) private var layout
    
    var body: some View {
        Text("한들")
            .font(.custom("EBSHunminjeongeumSB", fixedSize: 35 * layout.screenRatio))
            .bold()
    }
}
