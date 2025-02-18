//
//  DrawingCanvas.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI
import UIKit

struct DrawingCanvas: UIViewRepresentable {
    @Binding var drawnImage: UIImage? // Store the drawing

    func makeUIView(context: Context) -> DrawingView {
        let view = DrawingView()
        view.backgroundColor = .white
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: DrawingView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, DrawingViewDelegate {
        var parent: DrawingCanvas

        init(_ parent: DrawingCanvas) {
            self.parent = parent
        }

        func didFinishDrawing(image: UIImage) {
            parent.drawnImage = image
        }
    }
}
