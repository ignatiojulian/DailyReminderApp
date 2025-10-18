//
//  DependencyContainer.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Data Sources
    private lazy var reminderLocalDataSource = ReminderLocalDataSource()
    private lazy var notificationDataSource = NotificationDataSource()
    
    // MARK: - Repositories
    private lazy var reminderRepository: ReminderRepositoryProtocol = ReminderRepository(localDataSource: reminderLocalDataSource)
    private lazy var notificationRepository: NotificationRepositoryProtocol = NotificationRepository(dataSource: notificationDataSource)
    
    // MARK: - Use Cases
    private lazy var getRemindersUseCase: GetRemindersUseCaseProtocol = GetRemindersUseCase(repository: reminderRepository)
    private lazy var manageReminderUseCase: ManageReminderUseCaseProtocol = ManageReminderUseCase(
        reminderRepository: reminderRepository,
        notificationRepository: notificationRepository
    )
    private lazy var notificationUseCase: NotificationUseCaseProtocol = NotificationUseCase(repository: notificationRepository)
    
    // MARK: - Coordinators
    lazy var appCoordinator = AppCoordinator()
    
    // MARK: - Factory Methods
    func reminderViewModel() -> RemindersViewModel {
        RemindersViewModel(
            getRemindersUseCase: getRemindersUseCase,
            manageReminderUseCase: manageReminderUseCase,
            notificationUseCase: notificationUseCase
        )
    }
}
