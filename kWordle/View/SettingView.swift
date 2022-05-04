//
//  SettingView.swift
//  한들
//
//  Created by 강희영 on 2022/04/27.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Binding var isSettingPresented: Bool
    @State var isHowToPlayPresented: Bool = false
    @State var isStatisticsPresented: Bool = false
    @State var isMailViewPresented: Bool = false
    @State var isNoMailWarningPresented: Bool = false
    @State var isUserCustomPresented: Bool = false
    @AppStorage("isHapticFeedbackOff") var isHapticFeedbackOff: Bool = false
    @AppStorage("isSoundOff") var isSoundOff: Bool = false
    @AppStorage("isColorWeakModeOn") var isColorWeakModeOn = false
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
                    withAnimation {
                        isSettingPresented.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .padding(.trailing, 24)
                }
            }
        }
        
    }
    
    fileprivate func hapticButton() -> some View {
        Toggle("진동", isOn: $isHapticFeedbackOff.not)
            .toggleStyle(SettingToggleStyleWithoutChev())
    }
    
    fileprivate func soundButton() -> some View {
        Toggle("소리", isOn: $isSoundOff.not)
            .toggleStyle(SettingToggleStyleWithoutChev())
    }
    
    fileprivate func colorWeakModeButton() -> some View {
        Toggle("색약 양식", isOn: $isColorWeakModeOn)
            .toggleStyle(SettingToggleStyleWithoutChev())
            .onChange(of: isColorWeakModeOn) { _ in
                mainViewModel.refreshViewForCWmode()
            }
    }
    
    fileprivate func howToPlayButton() -> Button<Text> {
        return Button {
            withAnimation {
                isHowToPlayPresented.toggle()
            }
        } label: {
            Text("풀이 방법")
                .foregroundColor(.hBlack)
        }
    }
    
    fileprivate func statisticButton() -> Button<Text> {
        return Button {
            withAnimation {
                isStatisticsPresented.toggle()
            }
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
            if MailView.canSendMail {
                withAnimation {
                    isMailViewPresented.toggle()
                }
            } else {
                isNoMailWarningPresented.toggle()
            }
        } label: {
            Text("편지 보내기")
                .foregroundColor(.hBlack)
        }.sheet(isPresented: $isMailViewPresented) {
            MailView(data: $mailData) { _ in }
        }.alert(isPresented: $isNoMailWarningPresented) {
            Alert(title: Text("편지를 보낼 수 없습니다"),
                  message: Text("42handeul@gmail.com으로 편지를 보내주세요"))
        }
    }
    
    private func userCustomButton() -> some View {
        ZStack {
            Image(systemName: isUserCustomPresented ? "chevron.down": "chevron.right")
                .font(.system(size: 12))
                .offset(x: -45)
            Text("사용자화")
    //                .offset(x: -12)
        }
        .onTapGesture {
            withAnimation {
                isUserCustomPresented.toggle()
            }
        }
    }
    
    fileprivate func SettingContents() -> some View {
        return VStack(alignment: .leading, spacing: 16) {
            userCustomButton()
            if isUserCustomPresented {
                VStack(spacing: 12) {
                    soundButton()
                    hapticButton()
                    colorWeakModeButton()
                }
                .font(.custom("EBSHMJESaeronL", size: 14))
            }
            NotificationCell()
                .environmentObject(notificationManager)
            howToPlayButton()
            statisticButton()
            //            appReviewButton()
            sendMailButton()
            Spacer()
        }
    }
    
    fileprivate func SettingBackgrounds() -> some View {
        Group {
            Color.black.ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    withAnimation {
                        isSettingPresented.toggle()
                    }
                }
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 320, height: 420)
                .foregroundColor(.hLigthGray)
        }
    }
    
    var body: some View {
        ZStack {
            SettingBackgrounds()
            VStack {
                TitleBar()
                    .foregroundColor(.hBlack)
                    .padding(.top, 24)
                    .padding(.bottom, 41)
                SettingContents()
                    .frame(width: 134, height: 350)
                    .font(.custom("EBSHMJESaeronL", size: 16))
            }
            .frame(width: 320, height: 420, alignment: .top)
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

extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
