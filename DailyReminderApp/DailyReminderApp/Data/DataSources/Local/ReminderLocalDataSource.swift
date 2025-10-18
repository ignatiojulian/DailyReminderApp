//
//  ReminderLocalDataSource.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation
import Combine

final class ReminderLocalDataSource {
    @Published private(set) var reminders: [ReminderModel] = []

    private let fileURL: URL
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = docs.appendingPathComponent("reminders.json")
        load()

        $reminders
            .debounce(for: DispatchQueue.SchedulerTimeType.Stride.milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] (_: [ReminderModel]) in self?.save() }
            .store(in: &cancellables)
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([ReminderModel].self, from: data)
            reminders = decoded
        } catch {
           
            reminders = []
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(reminders)
            try data.write(to: fileURL, options: Data.WritingOptions.atomic)
        } catch {
            print("Failed to save reminders: \(error)")
        }
    }

    // CRUD operations
    func add(_ reminder: ReminderModel) {
        reminders.append(reminder)
        reminders = reminders.sortedByDueDate()
    }

    func update(_ reminder: ReminderModel) {
        if let idx = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[idx] = reminder
            reminders = reminders.sortedByDueDate()
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            reminders.remove(at: index)
        }
    }

    func delete(_ reminder: ReminderModel) {
        reminders.removeAll { $0.id == reminder.id }
    }

    func toggleCompleted(_ reminder: ReminderModel) {
        guard let idx = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[idx].isCompleted.toggle()
    }
}
