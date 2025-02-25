//
//  NotesViewModel.swift
//  SmartNotes
//
//  Created by Md Alif Hossain on 18/2/25.
//

import CoreData
import UserNotifications

class NotesViewModel: NotesStorageable {
    
    // MARK: - Properties
    @Published var notes: [Note] = []
    let context: NSManagedObjectContext = PersistenceController.shared.context
    
    // MARK: - UI Events
    enum Event {
        case delete(note: Note)
        case save
    }
    
    // MARK: - Init
    init() {
        loadNotes()
        requestNotificationPermission()
        print("***** NotesViewModel created *****")
    }
    
    deinit {
        print("--- NotesViewModel deallocated ---")
    }
    
    // MARK: - Public Methods
    func eventHandler(_ event: Event) {
        switch event {
        case .delete(let note):
            deleteNote(note)
        case .save:
            saveContext()
        }
    }
    
    // MARK: - Notification Handling
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
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}
