//
//  AddNoteView.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var reminderDate = Date()
    var viewModel: NotesViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                
                TextEditor(text: $content)
                    .frame(height: 200)

                DatePicker("Set Reminder", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newNote = viewModel.addNote(title: title, content: content)
                        if let newNote = newNote {
                            viewModel.eventHandeler(.notification(note: newNote, date: reminderDate))
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
