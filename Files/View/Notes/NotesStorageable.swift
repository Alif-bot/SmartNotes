//
//  NotesStorageable.swift
//  SmartNotes
//
//  Created by Md Alif Hossain on 20/2/25.
//

import CoreData

protocol NotesStorageable: ObservableObject {
    var notes: [Note] { get set }
    var context: NSManagedObjectContext { get }

    func loadNotes()
    func addNote(title: String, content: String) -> Note?
    func deleteNote(_ note: Note)
    func saveContext()
}

extension NotesStorageable {
    
    func loadNotes() {
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
        loadNotes()
        
        return newNote
    }

    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
        loadNotes()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
