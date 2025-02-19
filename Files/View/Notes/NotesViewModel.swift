//
//  NotesViewModel.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI
import CoreData

class NotesViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var notes: [Note] = []

    private let context = PersistenceController.shared.context
    
    // MARK: - UI Events
    
    enum Event {
        case delete(note: Note)
        case save
        case notification(note: Note, date: Date)
    }
    
    // MARK: - Init
    
    init() {
        fetchNotes()
        requestNotificationPermission()
        
        print("***** NotesViewModel created *****")
    }
    
    deinit {
        print("--- NotesViewModel deallocated ---")
    }
    
    // MARK: - Public Methods
    
    func eventHandeler(_ event: Event) {
        switch event {
            
        case .delete(let note):
            deleteNote(note)
            
        case .save:
            saveContext()
            
        case .notification(let note, let date):
            scheduleNotification(for: note, at: date)
        }
    }

    private func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching notes: \(error.localizedDescription)")
        }
    }

   func addNote(title: String, content: String) -> Note? {
        let newNote = Note(context: context)
        newNote.title = title
        newNote.content = content
        newNote.createdAt = Date()

        saveContext()
        fetchNotes()
        
        return newNote
    }

    private func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
        fetchNotes()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    private func scheduleNotification(for note: Note, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(note.title ?? "Untitled")"
        content.body = note.content ?? "No content"
        content.sound = .default
        
        let calendar = Calendar.current
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
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
