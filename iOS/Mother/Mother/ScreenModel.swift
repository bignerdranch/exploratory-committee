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
    let _id: String
    let name: String
    let url: URL?
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
        guard let img1 = UIImage(named: "Option 1 - Screen 0"), let data1 = img1.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img2 = UIImage(named: "Option 1 - Screen 1"), let data2 = img2.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img3 = UIImage(named: "Option 1 - Screen 2"), let data3 = img3.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img4 = UIImage(named: "Option 1 - Screen 3"), let data4 = img4.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img5 = UIImage(named: "Option 1 - Screen 4"), let data5 = img5.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img6 = UIImage(named: "Option 1 - Screen 5"), let data6 = img6.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img7 = UIImage(named: "Option 1 - Screen 6"), let data7 = img7.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img8 = UIImage(named: "Option 1 - Screen 7"), let data8 = img8.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        let sq1uuid = UUID()
        let sq2uuid = UUID()
        let sq3uuid = UUID()
        let sq4uuid = UUID()
        let sq5uuid = UUID()
        let sq6uuid = UUID()
        let sq7uuid = UUID()
        let sq8uuid = UUID()

        let wholeScreen = Rect(origin: Point(x: 0, y: 0), size: Size(width: 368, height: 448))
        
        let sq1 = Screen(uuid: sq1uuid, imageData: data1, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 130), size: Size(width: 360, height: 100)), target: sq2uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq2 = Screen(uuid: sq2uuid, imageData: data2, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 240), size: Size(width: 360, height: 90)), target: sq3uuid, transition: .fromLeft, trigger: .tap),
        ])
        let sq3 = Screen(uuid: sq3uuid, imageData: data3, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 460), size: Size(width: 360, height: 100)), target: sq4uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq4 = Screen(uuid: sq4uuid, imageData: data4, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 140), size: Size(width: 340, height: 140)), target: sq5uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq5 = Screen(uuid: sq5uuid, imageData: data5, hotspots: [
            Hotspot(rect: wholeScreen, target: sq6uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq6 = Screen(uuid: sq6uuid, imageData: data6, hotspots: [
            Hotspot(rect: wholeScreen, target: sq7uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq7 = Screen(uuid: sq7uuid, imageData: data7, hotspots: [
            Hotspot(rect: wholeScreen, target: sq8uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq8 = Screen(uuid: sq8uuid, imageData: data8, hotspots: [
            Hotspot(rect: wholeScreen, target: sq1uuid, transition: .fromRight, trigger: .tap),
        ])
        let url = URL(string: "https://www.google.com/")!
        let project = Project(_id: UUID().uuidString, name: "My Project", url: url, screens: [sq1, sq2, sq3, sq4, sq5, sq6, sq7, sq8])
        return project
    }
}


/**
 
 
 */
