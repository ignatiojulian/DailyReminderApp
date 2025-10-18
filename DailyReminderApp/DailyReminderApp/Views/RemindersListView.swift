//
//  RemindersListView.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

struct RemindersListView: View {
    @StateObject private var vm = RemindersViewModel()
    @State private var selectedReminder: Reminder? = nil
    @State private var showingAddSheet = false

    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    if !vm.upcomingReminders.isEmpty {
                        Section("Upcoming") {
                            ForEach(vm.upcomingReminders) { reminder in
                                ReminderRow(reminder: reminder, toggle: {
                                    vm.toggleCompleted(reminder)
                                })
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedReminder = reminder
                                }
                            }
                            .onDelete { offsets in
                                vm.delete(at: offsets)
                            }
                        }
                    }
                    if !vm.completedReminders.isEmpty {
                        Section("Completed") {
                            ForEach(vm.completedReminders) { reminder in
                                ReminderRow(reminder: reminder, toggle: {
                                    vm.toggleCompleted(reminder)
                                })
                            }
                        }
                    }
                }
                .navigationTitle("Reminders")
                .sheet(item: $selectedReminder) { reminder in
                    ReminderFormView(reminder: reminder) { title, notes, dueDate in
                        vm.update(reminder: reminder, title: title, notes: notes, dueDate: dueDate)
                        selectedReminder = nil
                    }
                    .onDisappear {
                        selectedReminder = nil
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    ReminderFormView(reminder: nil) { title, notes, dueDate in
                        vm.add(title: title, notes: notes, dueDate: dueDate)
                        showingAddSheet = false
                    }
                    .onDisappear {
                        showingAddSheet = false
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        selectedReminder = nil
                        showingAddSheet = true
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

private struct ReminderRow: View {
    let reminder: Reminder
    let toggle: () -> Void

    var body: some View {
        HStack {
            Button(action: toggle) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                if let due = reminder.dueDate {
                    Text(due.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    RemindersListView()
}
