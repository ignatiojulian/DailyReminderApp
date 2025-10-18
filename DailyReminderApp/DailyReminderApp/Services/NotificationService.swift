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
        guard reminder.shouldNotify, let dueDate = reminder.dueDate else { return }
        guard dueDate.timeIntervalSinceNow > 1 else {
            print("[Notification] Skipping scheduling: dueDate is in the past or too soon: \(dueDate)")
            return
        }
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder App"
        content.body = "\(reminder.title) at \(dueDate.formatted(date: .omitted, time: .shortened))"
        content.sound = .default
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
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
