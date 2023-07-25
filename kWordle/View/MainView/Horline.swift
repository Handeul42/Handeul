//
//  Horline.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/07.
//

import SwiftUI

struct Horline: View {
    let width: CGFloat
    let height: CGFloat
    
    init(height: CGFloat, width: CGFloat = uiSize.width - 40) {
        self.height = height
        self.width = width
    }
    var body: some View {
        Rectangle()
            .fill(Color.hRed)
            .frame(width: width, height: height)
    }
}

struct Horline_Previews: PreviewProvider {
    static var previews: some View {
        Horline(height: 2)
    }
}
