//
//  AddNoteView.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddNoteViewModel
    
    init(viewModel: @autoclosure @escaping () -> AddNoteViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $viewModel.title)
                
                TextEditor(text: $viewModel.content)
                    .frame(height: 200)
                
                DatePicker("Set Reminder", selection: $viewModel.reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.eventHandler(.save)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
    }
}
