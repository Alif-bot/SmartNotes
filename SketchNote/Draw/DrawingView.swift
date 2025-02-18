//
//  DrawingView.swift
//  SketchNote
//
//  Created by Md Alif Hossain on 18/2/25.
//

import UIKit

protocol DrawingViewDelegate: AnyObject {
    func didFinishDrawing(image: UIImage)
}

class DrawingView: UIView {
    private var path = UIBezierPath()
    private var lines: [[CGPoint]] = [] // Store drawn lines
    weak var delegate: DrawingViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isMultipleTouchEnabled = false
        backgroundColor = .white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        lines.append([point])
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard var lastLine = lines.popLast() else { return }
        let point = touch.location(in: self)
        lastLine.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(2)
        context?.setLineCap(.round)

        for line in lines {
            guard let firstPoint = line.first else { continue }
            context?.beginPath()
            context?.move(to: firstPoint)
            for point in line.dropFirst() {
                context?.addLine(to: point)
            }
            context?.strokePath()
        }
    }

    func saveDrawing() {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let drawnImage = image {
            delegate?.didFinishDrawing(image: drawnImage)
        }
    }

    func clearDrawing() {
        lines.removeAll()
        setNeedsDisplay()
    }
}
