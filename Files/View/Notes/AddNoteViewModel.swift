//
//  AddNoteViewModel.swift
//  SmartNotes
//
//  Created by Md Alif Hossain on 19/2/25.
//

import SwiftUI
import CoreData
import UserNotifications

class AddNoteViewModel: NotesStorageable, ObservableObject {
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Properties
    @Published var notes: [Note] = []
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var reminderDate: Date = Date()

    let context: NSManagedObjectContext = PersistenceController.shared.context

    var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - UI Events
    enum Event {
        case save
        case notification(note: Note, date: Date)
    }

    // MARK: - Public Methods
    func eventHandler(_ event: Event) {
        switch event {
        case .save:
            saveNote()
        case .notification(let note, let date):
            scheduleNotification(for: note, at: date)
        }
    }

    // MARK: - Init
    init() {
        loadNotes()
        print("***** AddNoteViewModel created *****")
    }

    deinit {
        print("--- AddNoteViewModel deallocated ---")
    }
    
    /// Saves the note and triggers a notification if a reminder is set.
    private func saveNote() {
        guard !isSaveDisabled else { return }

        if let newNote = addNote(title: title, content: content) {
            eventHandler(.notification(note: newNote, date: reminderDate))
        }
    }

    private func scheduleNotification(for note: Note, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(note.title ?? "Untitled")"
        content.body = note.content ?? "No content"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: note.objectID.uriRepresentation().absoluteString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}

