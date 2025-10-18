//
//  NotificationRepositoryProtocol.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

protocol NotificationRepositoryProtocol {
    func requestAuthorization() async throws -> Bool
    func scheduleNotification(for reminder: ReminderModel) async throws
    func removeNotification(for reminderID: UUID) async throws
}
