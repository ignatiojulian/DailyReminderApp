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
    func scheduleNotification(for reminder: ReminderModel)
    func removeNotification(for reminderID: UUID)
}

protocol ReminderStoreProtocol: ObservableObject {
    var reminders: [ReminderModel] { get }
    var remindersPublisher: Published<[ReminderModel]>.Publisher { get }
    
    func load()
    func save()
    func add(_ reminder: ReminderModel)
    func update(_ reminder: ReminderModel)
    func delete(at offsets: IndexSet)
    func delete(_ reminder: ReminderModel)
    func toggleCompleted(_ reminder: ReminderModel)
}
