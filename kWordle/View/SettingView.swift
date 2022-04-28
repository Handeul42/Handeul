//
//  SettingView.swift
//  한들
//
//  Created by 강희영 on 2022/04/27.
//

import SwiftUI

struct SettingView: View {
    @Binding var isSettingPresented: Bool
    @State var isHowToPlayPresented: Bool = false
    @State var isStatisticsPresented: Bool = false
    @ObservedObject private var notificationManager: NotificationManager = NotificationManager()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    isSettingPresented.toggle()
                }
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 320, height: 420)
                .foregroundColor(.hLigthGray)
            VStack {
                Text("설정")
                    .foregroundColor(getColor(of: .black))
                    .font(.custom("EBSHMJESaeronR", size: 20))
                VStack(alignment: .leading, spacing: 8) {
                    NotificationCell()
                        .environmentObject(notificationManager)
                    Button {
                        isHowToPlayPresented.toggle()
                    } label: {
                        Text("풀이 방법")
                            .foregroundColor(.hBlack)
                    }
                    Button {
                        isStatisticsPresented.toggle()
                    } label: {
                        Text("통계")
                    }
                    Button {
                        if let appstoreURL = URL(string: "https://apps.apple.com/us/app/한들/id1619947572") {
                            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
                            components?.queryItems = [
                              URLQueryItem(name: "action", value: "write-review")
                            ]
                            guard let writeReviewURL = components?.url else {
                                return
                            }
                            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Text("평가 하기")
                            .foregroundColor(.hBlack)
                    }
                    Text("편지 보내기")
                    Spacer()
                }
                .frame(width: 154, height: 228)
                .font(.custom("EBSHMJESaeronL", size: 16))
            }
            if isHowToPlayPresented {
                HowToPlayView(isHowToPlayPresented: $isHowToPlayPresented)
                    .zIndex(1)
            }
            if isStatisticsPresented {
                StatisticsView(isStatisticsPresented: $isStatisticsPresented)
            }
        }
        
    }
}

struct SettingButtonView: View {
    @Binding var isSettingPresented: Bool
    let buttonSize: CGFloat = 24 * currentScreenRatio()
    var body: some View {
        Button {
            withAnimation {
                isSettingPresented.toggle()
            }
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(.hBlack)
        }
    }
}
