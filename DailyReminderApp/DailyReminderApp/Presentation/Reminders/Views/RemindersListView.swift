//
//  RemindersListView.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

struct RemindersListView: View {
    @ObservedObject private var viewModel: RemindersViewModel
    @ObservedObject private var coordinator: RemindersCoordinator
    
    init(viewModel: RemindersViewModel, coordinator: RemindersCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    if !viewModel.upcomingReminders.isEmpty {
                        Section("Upcoming") {
                            ForEach(viewModel.upcomingReminders) { reminder in
                                ReminderRow(reminder: reminder, toggle: {
                                    viewModel.toggleCompleted(reminder)
                                })
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    coordinator.showEditReminder(reminder)
                                }
                            }
                            .onDelete { offsets in
                                viewModel.delete(at: offsets)
                            }
                        }
                    }
                    if !viewModel.completedReminders.isEmpty {
                        Section("Completed") {
                            ForEach(viewModel.completedReminders) { reminder in
                                ReminderRow(reminder: reminder, toggle: {
                                    viewModel.toggleCompleted(reminder)
                                })
                            }
                        }
                    }
                }
                .navigationTitle("Reminders")
                .sheet(item: $coordinator.selectedReminder) { reminder in
                    ReminderFormView(reminder: reminder) { title, notes, dueDate in
                        viewModel.update(reminder: reminder, title: title, notes: notes, dueDate: dueDate)
                        coordinator.dismissSheets()
                    }
                    .onDisappear {
                        coordinator.dismissSheets()
                    }
                }
                .sheet(isPresented: $coordinator.showingAddSheet) {
                    ReminderFormView(reminder: nil) { title, notes, dueDate in
                        viewModel.add(title: title, notes: notes, dueDate: dueDate)
                        coordinator.dismissSheets()
                    }
                    .onDisappear {
                        coordinator.dismissSheets()
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        coordinator.showAddReminder()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.accentColor))
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    RemindersListView(
        viewModel: DependencyContainer.shared.reminderViewModel(),
        coordinator: RemindersCoordinator()
    )
}
