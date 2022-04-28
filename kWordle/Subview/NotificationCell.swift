//
//  NotificationCell.swift
//  한들
//
//  Created by 강희영 on 2022/04/27.
//

import SwiftUI

struct NotificationCell: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        VStack {
            HStack {
                Toggle("새 문제 알림", isOn: $notificationManager.isNotiOn)
                    .frame(width: 154)
                    .toggleStyle(SettingToggleStyle())
            }
            if notificationManager.isNotiOn {
                DatePicker("", selection: $notificationManager.notiTime,
                           displayedComponents: .hourAndMinute)
            }
        }
        .alert(isPresented: $notificationManager.isAlertOccurred) {
            Alert(
                title: Text(Message.notiDeniedInSettingsTitle),
                message: Text(Message.notiDeniedInSettingsMessage),
                primaryButton: .default(Text("취소"), action: {
                    notificationManager.isNotiOn = false
                }),
                secondaryButton: .cancel(Text("설정으로 이동"), action: {
                    notificationManager.isNotiOn = false
                    openSettings()
                }))
        }
    }
    private func openSettings() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
    }
}
