//
//  ScreenModel.swift
//  Mother
//
//  Created by Steve Sparks on 9/23/20.
//

import UIKit

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

extension Project {
    func screen(with id: UUID) -> Screen? {
        for scr in screens {
            if scr.uuid == id { return scr }
        }
        return nil
    }
    
    static func demoProject() -> Project {
        guard let img = UIImage(named: "pixo"), let data = img.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        let sq1uuid = UUID()
        let sq2 = Screen(uuid: UUID(), imageData: data, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 40, y: 80), size: Size(width: 300, height: 100)), target: sq1uuid, transition: .fromLeft, trigger: .tap),
            Hotspot(rect: Rect(origin: Point(x: 40, y: 1050), size: Size(width: 300, height: 100)), target: sq1uuid, transition: .fromLeft, trigger: .tap)
        ])
        let sq1 = Screen(uuid: sq1uuid, imageData: data, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 40, y: 80), size: Size(width: 300, height: 100)), target: sq2.uuid, transition: .fromRight, trigger: .tap),
            Hotspot(rect: Rect(origin: Point(x: 40, y: 1050), size: Size(width: 300, height: 100)), target: sq2.uuid, transition: .fromRight, trigger: .tap)
        ])
        let project = Project(uuid: UUID(), name: "My Project", screens: [sq1, sq2])
        return project
    }
}


/**
 
 
 */
