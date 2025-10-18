//
//  ReminderFormView.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import SwiftUI

struct ReminderFormView: View {
    let reminder: Reminder?
    let onSave: (_ title: String, _ notes: String?, _ dueDate: Date?, _ shouldNotify: Bool) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()
    @State private var shouldNotify: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes)
                }
                Section("Schedule") {
                    Toggle("Has due date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        Toggle("Notify me", isOn: $shouldNotify)
                    }
                }
            }
            .navigationTitle(reminder == nil ? "New Reminder" : "Edit Reminder")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let notesText = notes.isEmpty ? nil : notes
                        let dateValue: Date? = hasDueDate ? dueDate : nil
                        onSave(title, notesText, dateValue, shouldNotify && hasDueDate)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let r = reminder {
                    title = r.title
                    notes = r.notes ?? ""
                    if let d = r.dueDate {
                        hasDueDate = true
                        dueDate = d
                    }
                    shouldNotify = r.shouldNotify
                }
            }
        }
    }
}

#Preview {
    ReminderFormView(reminder: nil) { _, _, _, _ in }
}