//
//  GetRemindersUseCase.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine

protocol GetRemindersUseCaseProtocol {
    var remindersPublisher: AnyPublisher<[ReminderModel], Never> { get }
    var upcomingReminders: [ReminderModel] { get }
    var completedReminders: [ReminderModel] { get }
    func execute() async throws
}

final class GetRemindersUseCase: GetRemindersUseCaseProtocol {
    private let repository: ReminderRepositoryProtocol
    
    init(repository: ReminderRepositoryProtocol) {
        self.repository = repository
    }
    
    var remindersPublisher: AnyPublisher<[ReminderModel], Never> {
        repository.remindersPublisher
    }
    
    var upcomingReminders: [ReminderModel] {
        repository.reminders.filter { !$0.isCompleted }.sortedByDueDate()
    }
    
    var completedReminders: [ReminderModel] {
        repository.reminders.filter { $0.isCompleted }.sortedByDueDate()
    }
    
    func execute() async throws {
        try await repository.loadReminders()
    }
}
