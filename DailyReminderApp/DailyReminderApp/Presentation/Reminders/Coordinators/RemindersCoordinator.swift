//
//  RemindersCoordinator.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI
import Combine

@MainActor
final class RemindersCoordinator: ObservableObject {
    @Published var selectedReminder: ReminderModel?
    @Published var showingAddSheet = false
    
    func showAddReminder() {
        selectedReminder = nil
        showingAddSheet = true
    }
    
    func showEditReminder(_ reminder: ReminderModel) {
        selectedReminder = reminder
    }
    
    func dismissSheets() {
        selectedReminder = nil
        showingAddSheet = false
    }
}
