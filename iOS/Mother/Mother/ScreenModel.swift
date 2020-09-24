//
//  ScreenModel.swift
//  Mother
//
//  Created by Steve Sparks on 9/23/20.
//

import Foundation

enum Transition: String, Codable {
    case fromLeft, fromRight, fromTop, fromBottom
    case fade, instant
}
enum Trigger: String, Codable {
    case swipeLeft, swipeRight, swipeUp, swipeDown
    case tap, longPress
}
struct Point: Codable {
    let x: Double
    let y: Double
}
struct Size: Codable {
    let width: Double
    let height: Double
}
struct Rect: Codable {
    let origin: Point
    let size: Size
}
struct Hotspot: Codable {
    let rect: Rect
    let target: UUID
    let transition: Transition
    let trigger: Trigger
}
struct Screen: Codable {
    let uuid: UUID
    let imageData: Data
    let hotspots: [Hotspot]
}
struct Project: Codable {
    let uuid: UUID
    let name: String
    let screens: [Screen]
}


/**
 
 
 */
