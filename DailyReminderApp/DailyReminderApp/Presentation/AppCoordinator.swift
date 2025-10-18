//
//  AppCoordinator.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    let remindersCoordinator = RemindersCoordinator()
    
    func makeRemindersView(with viewModel: RemindersViewModel) -> some View {
        RemindersListView(viewModel: viewModel, coordinator: remindersCoordinator)
    }
}