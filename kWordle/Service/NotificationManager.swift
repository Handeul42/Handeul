//
//  NotificationManager.swift
//  한들
//
//  Created by 강희영 on 2022/04/27.
//

import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    
    // Notification Center
    private let userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    // Check If Alert Occurred: When User tapped Toggle but the notification of the app is Denied
    @Published var isAlertOccurred: Bool = false

    // Check If Toggle clicked
    @Published var isNotiOn: Bool = UserDefaults.standard.bool(forKey: "hasUserAgreedAlert") {
        didSet {
            if isNotiOn {
                // If Notification On, Request Authorization
                UserDefaults.standard.set(true, forKey: "hasUserAgreedAlert")
                requestNotificationAuthorization()
            }
            else {
                // If Notification Off, Remove All Notifications
                UserDefaults.standard.set(false, forKey: "hasUserAgreedAlert")
                removeAllNotifications()
            }
        }
    }

    // Time to notify
    @Published var notiTime: Date = UserDefaults.standard.object(forKey: "userNotiTime") as? Date ?? Date() {
        didSet {
            removeAllNotifications()
            addNotification(with: notiTime)
            UserDefaults.standard.set(notiTime, forKey: "userNotiTime")
        }
    }
    
    // Remove All Remaining Notifications
    func removeAllNotifications() {
        userNotificationCenter.removeAllDeliveredNotifications()
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
    
    // Request Notification Authorization
    func requestNotificationAuthorization() {
        userNotificationCenter.getNotificationSettings { settings in
            // If Not Authorized, request Authorization
            if settings.authorizationStatus != .authorized {
                self.userNotificationCenter
                    .requestAuthorization(options: [.alert, .sound]) { granted, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        if granted {
                            self.addNotification(with: self.notiTime)
                        }
                        else {
                            DispatchQueue.main.async {
                                self.isNotiOn = false
                            }
                        }
                    }
            }
            
            // If Denied, Occur Alert
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.isAlertOccurred = true
                }
            }
        }
    }
    
    // Add Notification with Specific Time
    func addNotification(with time: Date) {
        let content = UNMutableNotificationContent()
        
        content.title = "한들"
        content.subtitle = "오늘의 문제가 도착했습니다!"
        content.sound = UNNotificationSound.default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        userNotificationCenter.add(request)
    }
}
