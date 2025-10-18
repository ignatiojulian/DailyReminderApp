//
//  RemindersViewModel.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine
import SwiftUI

final class RemindersViewModel: ObservableObject {
    @Published private(set) var reminders: [Reminder] = []

    private let store: any ReminderStoreProtocol
    private let notifications: NotificationServiceProtocol

    init(store: any ReminderStoreProtocol, notificationService: NotificationServiceProtocol) {
        self.store = store
        self.notifications = notificationService
        self.reminders = store.reminders

        store.remindersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                self?.reminders = reminders
            }
            .store(in: &cancellables)

        notifications.requestAuthorization(completion: nil)
    }

    private var cancellables: Set<AnyCancellable> = []

    var upcomingReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }.sortedByDueDate()
    }

    var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }.sortedByDueDate()
    }

    func add(title: String, notes: String?, dueDate: Date?) {
        let reminder = Reminder(title: title, notes: notes, dueDate: dueDate, isCompleted: false)
        store.add(reminder)
        notifications.scheduleNotification(for: reminder)
    }

    func update(reminder: Reminder, title: String, notes: String?, dueDate: Date?) {
        var updated = reminder
        updated.title = title
        updated.notes = notes
        updated.dueDate = dueDate
        store.update(updated)
        notifications.removeNotification(for: updated.id)
        notifications.scheduleNotification(for: updated)
    }

    func delete(at offsets: IndexSet) {
        let toDelete = offsets.map { upcomingReminders[$0] }
        toDelete.forEach { rem in
            notifications.removeNotification(for: rem.id)
            store.delete(rem)
        }
    }

    func toggleCompleted(_ reminder: Reminder) {
        store.toggleCompleted(reminder)
        if reminder.isCompleted {
            notifications.removeNotification(for: reminder.id)
        } else if let _ = reminder.dueDate {
            notifications.scheduleNotification(for: reminder)
        }
    }
}

