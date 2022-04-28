//
//  StatisticView.swift
//  kWordle
//
//  Created by JaemooJung on 2022/04/19.
//

import SwiftUI

struct StatisticView: View {
    @Binding var isStatisticsPresented: Bool
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    isStatisticsPresented.toggle()
                }
            } label: {
                Image(systemName: "xmark")
            }
            Text("StatisticView")
        }
    }
}

//struct StatisticView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticView()
//    }
//}
