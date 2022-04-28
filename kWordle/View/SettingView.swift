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
    @State var isMailViewPresented: Bool = false
    @ObservedObject private var notificationManager: NotificationManager = NotificationManager()
    @State private var mailData = ComposeMailData(subject: "한들에 대하여 :",
                                                  recipients: ["42handeul@gmail.com"],
                                                  message: "",
                                                  attachments: nil)
    
    fileprivate func TitleBar() -> some View {
        return ZStack {
            Text("설정")
                .font(.custom("EBSHMJESaeronR", size: 22))
            HStack {
                Spacer()
                Button {
                    isSettingPresented.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .padding(.trailing, 24)
                }
            }
        }
    }
    
    fileprivate func howToPlayButton() -> Button<Text> {
        return Button {
            isHowToPlayPresented.toggle()
        } label: {
            Text("풀이 방법")
                .foregroundColor(.hBlack)
        }
    }
    
    fileprivate func statisticButton() -> Button<Text> {
        return Button {
            isStatisticsPresented.toggle()
        } label: {
            Text("통계")
                .foregroundColor(.hBlack)
        }
    }
    
    fileprivate func appReviewButton() -> Button<Text> {
        return Button {
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
    }
    
    fileprivate func sendMailButton() -> some View {
        return Button {
            withAnimation {
                isMailViewPresented.toggle()
            }
        } label: {
            Text(MailView.canSendMail ? "편지 보내기" : "편지 보내기(메일X)")
                .foregroundColor(.hBlack)
        }.disabled(!MailView.canSendMail)
            .sheet(isPresented: $isMailViewPresented) {
                MailView(data: $mailData) { _ in }
            }
    }
    
    fileprivate func SettingContents() -> some View {
        return VStack(alignment: .leading, spacing: 16) {
            NotificationCell()
                .environmentObject(notificationManager)
            howToPlayButton()
            statisticButton()
            appReviewButton()
            sendMailButton()
            Spacer()
        }
    }
    
    fileprivate func SettingBackgrounds() -> some View {
        Group {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    isSettingPresented.toggle()
                }
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 320, height: 420)
                .foregroundColor(.hLigthGray)
        }
    }
    
    var body: some View {
        ZStack {
            SettingBackgrounds()
            Group {
                VStack(spacing: 0) {
                    TitleBar()
                        .foregroundColor(.hBlack)
                        .padding(.top, 24)
                    Spacer()
                    SettingContents()
                        .frame(width: 134, height: 228)
                        .font(.custom("EBSHMJESaeronL", size: 16))
                    Spacer()
                }
            }
            .frame(width: 320, height: 420)
            if isHowToPlayPresented {
                HowToPlayView(isHowToPlayPresented: $isHowToPlayPresented)
                    .zIndex(1)
            }
            if isStatisticsPresented {
                StatisticsView(isStatisticsPresented: $isStatisticsPresented)
                    .zIndex(2)
            }
        }
        
    }
}

struct SettingButtonView: View {
    @Binding var isSettingPresented: Bool
    let buttonSize: CGFloat = 32
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
