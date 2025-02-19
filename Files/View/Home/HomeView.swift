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
    @State private var animateList = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.notes.enumerated()), id: \.element.objectID) { index, note in
                    VStack(alignment: .leading) {
                        Text(note.title ?? "Untitled")
                            .font(.headline)
                        Text(note.content ?? "No content")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
                    .opacity(animateList ? 1 : 0) // Start with opacity 0
                    .offset(y: animateList ? 0 : 20) // Move down slightly
                    .animation(.easeOut.delay(Double(index) * 0.1), value: animateList)
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("Smart Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddNote.toggle()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .scaleEffect(showAddNote ? 1.2 : 1.0) // Scale effect
                            .animation(.spring(), value: showAddNote)
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(viewModel: viewModel)
            }
            .onAppear {
                animateList = true
            }
        }
    }
    
    private func deleteNote(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = viewModel.notes[index]
            viewModel.eventHandeler(.delete(note: note))
        }
    }
}
