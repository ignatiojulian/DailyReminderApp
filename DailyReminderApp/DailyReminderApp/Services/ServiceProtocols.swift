//
//  ServiceProtocols.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: ((Bool) -> Void)?)
    func scheduleNotification(for reminder: Reminder)
    func removeNotification(for reminderID: UUID)
}

protocol ReminderStoreProtocol: ObservableObject {
    var reminders: [Reminder] { get }
    var remindersPublisher: Published<[Reminder]>.Publisher { get }
    
    func load()
    func save()
    func add(_ reminder: Reminder)
    func update(_ reminder: Reminder)
    func delete(at offsets: IndexSet)
    func delete(_ reminder: Reminder)
    func toggleCompleted(_ reminder: Reminder)
}
