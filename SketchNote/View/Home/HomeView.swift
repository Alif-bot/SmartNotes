//
//  HomeView.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showAddNote = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes, id: \.objectID) { note in
                    VStack(alignment: .leading) {
                        Text(note.title ?? "Untitled")
                            .font(.headline)
                        Text(note.content ?? "No content")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("SketchNote")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddNote.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(viewModel: viewModel)
            }
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = viewModel.notes[index]
            viewModel.deleteNote(note)
        }
    }
}

