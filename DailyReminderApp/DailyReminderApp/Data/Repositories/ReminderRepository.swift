//
//  ReminderRepository.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine

final class ReminderRepository: ReminderRepositoryProtocol {
    private let localDataSource: ReminderLocalDataSource
    
    init(localDataSource: ReminderLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    var reminders: [ReminderModel] {
        localDataSource.reminders
    }
    
    var remindersPublisher: AnyPublisher<[ReminderModel], Never> {
        localDataSource.$reminders.eraseToAnyPublisher()
    }
    
    func loadReminders() async throws {
        localDataSource.load()
    }
    
    func saveReminders() async throws {
        localDataSource.save()
    }
    
    func addReminder(_ reminder: ReminderModel) async throws {
        localDataSource.add(reminder)
    }
    
    func updateReminder(_ reminder: ReminderModel) async throws {
        localDataSource.update(reminder)
    }
    
    func deleteReminder(at offsets: IndexSet) async throws {
        localDataSource.delete(at: offsets)
    }
    
    func deleteReminder(_ reminder: ReminderModel) async throws {
        localDataSource.delete(reminder)
    }
    
    func toggleReminderCompleted(_ reminder: ReminderModel) async throws {
        localDataSource.toggleCompleted(reminder)
    }
}
