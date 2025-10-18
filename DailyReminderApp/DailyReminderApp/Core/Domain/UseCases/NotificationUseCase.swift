//
//  NotificationUseCase.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

protocol NotificationUseCaseProtocol {
    func requestAuthorization() async throws -> Bool
}

final class NotificationUseCase: NotificationUseCaseProtocol {
    private let repository: NotificationRepositoryProtocol
    
    init(repository: NotificationRepositoryProtocol) {
        self.repository = repository
    }
    
    func requestAuthorization() async throws -> Bool {
        try await repository.requestAuthorization()
    }
}
