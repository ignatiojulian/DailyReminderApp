//
//  ManageReminderUseCase.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

protocol ManageReminderUseCaseProtocol {
    func addReminder(title: String, notes: String?, dueDate: Date?) async throws
    func updateReminder(_ reminder: ReminderModel, title: String, notes: String?, dueDate: Date?) async throws
    func deleteReminder(at offsets: IndexSet) async throws
    func toggleReminderCompleted(_ reminder: ReminderModel) async throws
}

final class ManageReminderUseCase: ManageReminderUseCaseProtocol {
    private let reminderRepository: ReminderRepositoryProtocol
    private let notificationRepository: NotificationRepositoryProtocol
    
    init(
        reminderRepository: ReminderRepositoryProtocol,
        notificationRepository: NotificationRepositoryProtocol
    ) {
        self.reminderRepository = reminderRepository
        self.notificationRepository = notificationRepository
    }
    
    func addReminder(title: String, notes: String?, dueDate: Date?) async throws {
        let reminder = ReminderModel(title: title, notes: notes, dueDate: dueDate, isCompleted: false)
        try await reminderRepository.addReminder(reminder)
        
        if dueDate != nil {
            try await notificationRepository.scheduleNotification(for: reminder)
        }
    }
    
    func updateReminder(_ reminder: ReminderModel, title: String, notes: String?, dueDate: Date?) async throws {
        var updatedReminder = reminder
        updatedReminder.title = title
        updatedReminder.notes = notes
        updatedReminder.dueDate = dueDate
        
        try await reminderRepository.updateReminder(updatedReminder)
        try await notificationRepository.removeNotification(for: updatedReminder.id)
        
        if dueDate != nil {
            try await notificationRepository.scheduleNotification(for: updatedReminder)
        }
    }
    
    func deleteReminder(at offsets: IndexSet) async throws {
        try await reminderRepository.deleteReminder(at: offsets)
    }
    
    func toggleReminderCompleted(_ reminder: ReminderModel) async throws {
        try await reminderRepository.toggleReminderCompleted(reminder)
        
        if reminder.isCompleted {
            try await notificationRepository.removeNotification(for: reminder.id)
        } else if reminder.dueDate != nil {
            try await notificationRepository.scheduleNotification(for: reminder)
        }
    }
}
