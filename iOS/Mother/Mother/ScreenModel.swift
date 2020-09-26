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
    static func from(_ string: String) -> Transition {
        switch string {
        case "left": return .fromLeft
        case "right": return .fromRight
        case "up": return .fromBottom
        case "down": return .fromTop
        case "instant": return .instant
        case "fade": return .fade
        default: return .fromRight
        }
    }
}
enum Trigger: String, Codable {
    case swipeLeft, swipeRight, swipeUp, swipeDown
    case tap, longPress
    
    static func trigger(from string: String) -> Trigger {
        switch string {
        case "swipeleft": return .swipeLeft
        case "swipeup": return .swipeUp
        case "swipedown": return .swipeDown
        case "swiperight": return .swipeRight
        case "tap": return .tap
        case "longpress": return .longPress
        default: return .tap
        }
    }

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
    let id: String
    let rect: Rect
    let target: String
    let transition: Transition
    let trigger: Trigger
    
    init(rect: Rect, target: String, transition: Transition, trigger: Trigger) {
        self.id = UUID().uuidString
        self.rect = rect
        self.target = target
        self.transition = transition
        self.trigger = trigger
    }
    enum CodingKeys: String, CodingKey {
        case id, x1, x2, y1, y2, trigger, transition, destination
    }
    
    init(from decoder: Decoder) throws {
        let ctr = try decoder.container(keyedBy: CodingKeys.self)
        id = try ctr.decode(String.self, forKey: .id)
        let x1 = try ctr.decode(Double.self, forKey: .x1)
        let x2 = try ctr.decode(Double.self, forKey: .x2)
        let y1 = try ctr.decode(Double.self, forKey: .x1)
        let y2 = try ctr.decode(Double.self, forKey: .y2)
        rect = Rect.rect(x1, x2, y1, y2)
        target = try ctr.decode(String.self, forKey: .destination)
        let triggerStr = try ctr.decode(String.self, forKey: .trigger)
        trigger = Trigger.trigger(from: triggerStr)
        let transitionStr = try ctr.decode(String.self, forKey: .transition)
        transition = Transition.from(transitionStr)
    }
    
    func encode(to encoder: Encoder) throws {
        var ctr = encoder.container(keyedBy: CodingKeys.self)
        try ctr.encode(id, forKey: .id)
        try ctr.encode(target, forKey: .destination)
        try ctr.encode(trigger, forKey: .trigger)
        try ctr.encode(transition, forKey: .transition)
        try ctr.encode(rect.origin.x, forKey: .x1)
        try ctr.encode(rect.origin.x + rect.size.width, forKey: .x2)
        try ctr.encode(rect.origin.y, forKey: .y1)
        try ctr.encode(rect.origin.y + rect.size.height, forKey: .y2)
    }
}
struct Screen: Codable {
    let uuid: String
    let url: String
    let name: String
    let firstScreen: Bool
    let hotspots: [Hotspot]?

    enum CodingKeys: String, CodingKey {
        case uuid, url, name, hotspots, firstScreen
    }
    init(uuid: String, url: String, name: String, firstScreen: Bool, hotspots: [Hotspot]?) {
        self.uuid = uuid
        self.url = url
        self.name = name
        self.firstScreen = firstScreen
        self.hotspots = hotspots
    }
    init(from decoder: Decoder) throws {
        let ctr = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try ctr.decode(String.self, forKey: .uuid)
        url = try ctr.decode(String.self, forKey: .url)
        name = try ctr.decode(String.self, forKey: .name)
        do {
            hotspots = try ctr.decode([Hotspot].self, forKey: .hotspots)
        } catch {
            hotspots = []
        }
        do {
            let f = try ctr.decode(Bool.self, forKey: .firstScreen)
            firstScreen = f
        } catch {
            firstScreen = false
        }
    }
}

struct Project: Codable {
    let _id: String
    let name: String
    let url: URL?
    let screens: [Screen]
}

extension Project {
    func screen(with id: String) -> Screen? {
        for scr in screens {
            if scr.uuid == id { return scr }
        }
        return nil
    }
    
    func firstScreen() -> Screen? {
        for screen in screens {
            if screen.firstScreen { return screen }
        }
        return screens.first
    }
}


/**
 
 
 */
extension Rect {
    static func rect(_ x1: Double, _ x2: Double, _ y1: Double, _ y2: Double) -> Rect {
        let originX = min(x1, x2)
        let originY = min(y1, y2)
        let width = fabs(x1 - x2)
        let height = fabs(y1 - y2)
        
        return Rect(origin: Point(x: originX, y: originY), size: Size(width: width, height: height))
    }
}
