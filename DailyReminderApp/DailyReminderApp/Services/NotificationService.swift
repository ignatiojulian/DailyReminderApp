//
//  NotificationService.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion?(granted)
            }
        }
    }

    func scheduleNotification(for reminder: Reminder) {
        guard let dueDate = reminder.dueDate else { return }
        
        let targetDate: Date
        if reminder.shouldNotify {
            targetDate = dueDate
        } else {
            targetDate = Calendar.current.date(byAdding: .minute, value: -10, to: dueDate) ?? dueDate.addingTimeInterval(-600)
        }

        if targetDate.timeIntervalSinceNow <= 1 {
            print("[Notification] Skipping scheduling: target date is in the past or too soon. Target: \(targetDate)")
            return
        }
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder App"
        if reminder.shouldNotify {
            content.body = "\(reminder.title) at \(dueDate.formatted(date: .omitted, time: .shortened))"
        } else {
            content.body = "Upcoming: \(reminder.title) due at \(dueDate.formatted(date: .omitted, time: .shortened))"
        }
        content.sound = .default
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                center.getPendingNotificationRequests { requests in
                    print("[Notification] Pending requests count: \(requests.count)")
                }
            }
        }
    }

    func removeNotification(for reminderID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderID.uuidString])
    }
}
