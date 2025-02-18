//
//  NotesViewModel.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI
import CoreData

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []

    private let context = PersistenceController.shared.context

    init() {
        fetchNotes()
    }

    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching notes: \(error.localizedDescription)")
        }
    }

    func addNote(title: String, content: String) {
        let context = PersistenceController.shared.container.viewContext
        let newNote = Note(context: context) // Correct way to initialize
        newNote.title = title
        newNote.content = content
        newNote.createdAt = Date()

        saveContext()
        fetchNotes()
    }

    func deleteNote(_ note: Note) {
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
}
