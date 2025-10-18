//
//  Reminder.swift
//  DailyReminderApp
//
//  Created by Ignatio Julian on 18/10/25.
//

import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var notes: String?
    var dueDate: Date?
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, notes: String? = nil, dueDate: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

extension Array where Element == Reminder {
    func sortedByDueDate() -> [Reminder] {
        self.sorted { lhs, rhs in
            switch (lhs.dueDate, rhs.dueDate) {
            case let (l?, r?):
                return l < r
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
        }
    }
}