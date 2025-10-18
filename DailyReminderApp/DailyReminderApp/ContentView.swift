//
//  ContentView.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    private let viewModel: RemindersViewModel
    
    init(viewModel: RemindersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        RemindersListView(viewModel: viewModel)
    }
}

#Preview {
    ContentView(viewModel: DependencyContainer.shared.makeRemindersViewModel())
}
