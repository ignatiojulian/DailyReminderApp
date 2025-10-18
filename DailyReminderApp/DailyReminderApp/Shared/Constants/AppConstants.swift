//
//  AppConstants.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

enum AppConstants {
    enum UserDefaults {
        static let remindersKey = "saved_reminders"
    }
    
    enum Notifications {
        static let categoryIdentifier = "REMINDER_CATEGORY"
        static let actionIdentifier = "COMPLETE_ACTION"
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
    }
    
    enum Animation {
        static let defaultDuration: Double = 0.3
        static let springResponse: Double = 0.5
        static let springDamping: Double = 0.8
    }
}