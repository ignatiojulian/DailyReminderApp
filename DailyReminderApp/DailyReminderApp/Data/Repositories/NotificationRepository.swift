//
//  NotificationRepository.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

final class NotificationRepository: NotificationRepositoryProtocol {
    private let dataSource: NotificationDataSource
    
    init(dataSource: NotificationDataSource) {
        self.dataSource = dataSource
    }
    
    func requestAuthorization() async throws -> Bool {
        return await withCheckedContinuation { continuation in
            dataSource.requestAuthorization { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func scheduleNotification(for reminder: ReminderModel) async throws {
        dataSource.scheduleNotification(for: reminder)
    }
    
    func removeNotification(for reminderID: UUID) async throws {
        dataSource.removeNotification(for: reminderID)
    }
}
