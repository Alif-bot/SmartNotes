//
//  DrawingViewScreen.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import SwiftUI

struct DrawingViewScreen: View {
    @State private var drawnImage: UIImage? = nil
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            DrawingCanvas(drawnImage: $drawnImage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )

            HStack {
                Button("Clear") {
                    drawnImage = nil
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Spacer()

                Button("Save") {
                    if let image = drawnImage {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
    }
}
