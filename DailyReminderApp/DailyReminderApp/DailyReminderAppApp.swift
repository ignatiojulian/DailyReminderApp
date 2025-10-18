//
//  DailyReminderAppApp.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

@main
struct DailyReminderAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let dependencyContainer = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: dependencyContainer.makeRemindersViewModel())
        }
    }
}
