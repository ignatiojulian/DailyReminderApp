//
//  ReminderRepositoryProtocol.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine

protocol ReminderRepositoryProtocol {
    var reminders: [ReminderModel] { get }
    var remindersPublisher: AnyPublisher<[ReminderModel], Never> { get }
    
    func loadReminders() async throws
    func saveReminders() async throws
    func addReminder(_ reminder: ReminderModel) async throws
    func updateReminder(_ reminder: ReminderModel) async throws
    func deleteReminder(at offsets: IndexSet) async throws
    func deleteReminder(_ reminder: ReminderModel) async throws
    func toggleReminderCompleted(_ reminder: ReminderModel) async throws
}
