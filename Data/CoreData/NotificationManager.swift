//
//  NotificationManager.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func setupNotifications(enabled: Bool) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.scheduleNotifications()
            }
        }
    }
    
    private func scheduleNotifications() {
        let settings = SettingsViewModel.shared
        
        if settings.dailyNotifications {
            scheduleDailyNotification()
        }
        
        if settings.inactiveProjectReminders {
            scheduleInactiveProjectReminder()
        }
    }
    
    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Knitting Reminder"
        content.body = "Don't forget to work on your knitting projects today!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10 // 10 AM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleInactiveProjectReminder() {
        // Implementation for inactive project reminders
    }
}
