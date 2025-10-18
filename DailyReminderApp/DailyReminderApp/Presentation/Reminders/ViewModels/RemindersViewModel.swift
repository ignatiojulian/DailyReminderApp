//
//  RemindersViewModel.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class RemindersViewModel: ObservableObject {
    @Published private(set) var reminders: [ReminderModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getRemindersUseCase: GetRemindersUseCaseProtocol
    private let manageReminderUseCase: ManageReminderUseCaseProtocol
    private let notificationUseCase: NotificationUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        getRemindersUseCase: GetRemindersUseCaseProtocol,
        manageReminderUseCase: ManageReminderUseCaseProtocol,
        notificationUseCase: NotificationUseCaseProtocol
    ) {
        self.getRemindersUseCase = getRemindersUseCase
        self.manageReminderUseCase = manageReminderUseCase
        self.notificationUseCase = notificationUseCase
        
        setupBindings()
        loadReminders()
        requestNotificationAuthorization()
    }
    
    var upcomingReminders: [ReminderModel] {
        getRemindersUseCase.upcomingReminders
    }
    
    var completedReminders: [ReminderModel] {
        getRemindersUseCase.completedReminders
    }
    
    private func setupBindings() {
        getRemindersUseCase.remindersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                self?.reminders = reminders
            }
            .store(in: &cancellables)
    }
    
    private func loadReminders() {
        Task {
            isLoading = true
            do {
                try await getRemindersUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func requestNotificationAuthorization() {
        Task {
            do {
                _ = try await notificationUseCase.requestAuthorization()
            } catch {
                errorMessage = "Failed to request notification authorization"
            }
        }
    }
    
    func add(title: String, notes: String?, dueDate: Date?) {
        Task {
            do {
                try await manageReminderUseCase.addReminder(title: title, notes: notes, dueDate: dueDate)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func update(reminder: ReminderModel, title: String, notes: String?, dueDate: Date?) {
        Task {
            do {
                try await manageReminderUseCase.updateReminder(reminder, title: title, notes: notes, dueDate: dueDate)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        Task {
            do {
                try await manageReminderUseCase.deleteReminder(at: offsets)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleCompleted(_ reminder: ReminderModel) {
        Task {
            do {
                try await manageReminderUseCase.toggleReminderCompleted(reminder)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
