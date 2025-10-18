//
//  ContentView.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    private let viewModel: RemindersViewModel
    private let coordinator: AppCoordinator
    
    init(viewModel: RemindersViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    var body: some View {
        coordinator.makeRemindersView(with: viewModel)
    }
}

#Preview {
    ContentView(
        viewModel: DependencyContainer.shared.reminderViewModel(),
        coordinator: DependencyContainer.shared.appCoordinator
    )
}
