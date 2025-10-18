//
//  DependencyContainer.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    lazy var notificationService: NotificationServiceProtocol = NotificationService()
    lazy var reminderStore: any ReminderStoreProtocol = ReminderStore()
    
    func makeRemindersViewModel() -> RemindersViewModel {
        RemindersViewModel(
            store: reminderStore,
            notificationService: notificationService
        )
    }
}
