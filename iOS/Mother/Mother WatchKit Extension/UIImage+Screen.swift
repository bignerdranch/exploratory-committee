//
//  UIImage+Screen.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/24/20.
//

import Foundation
import CoreGraphics
import UIKit

extension Size {
    var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

extension Point {
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension Rect {
    var cgRect: CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

extension Hotspot {
    static var cornerRadius: CGFloat = 20.0
    static var strokeWidth: CGFloat = 8.0
    static var strokeColor: CGColor = UIColor.white.cgColor
    static var fillColor: CGColor = UIColor(red: 0.3, green: 0.9, blue: 0.2, alpha: 0.8).cgColor
    
    var cgRect: CGRect { return rect.cgRect }
    
    func draw(into context: CGContext) {
        context.beginPath()
        let path = UIBezierPath(roundedRect: cgRect, cornerRadius: Hotspot.cornerRadius)
        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)
    }
}
