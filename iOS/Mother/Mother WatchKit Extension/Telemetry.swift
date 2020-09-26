//
//  Telemetry.swift
//  Geoffrey Watch Extension
//
//  Created by Steve Sparks on 9/26/20.
//

import UIKit

class Telemetry {
    static private let url = URL(string: "https://immense-bastion-45421.herokuapp.com/telemetry")!
    
    enum EventType: String, Codable {
        case tap, longPress
        case swipeRight, swipeLeft, swipeUp, swipeDown
    }
    struct Report: Codable {
        var action: EventType
        var currentScreen: String
        var destinationScreen: String?
        var positionX: Double
        var positionY: Double
        var projectId: String
        var runId: String
    }
    
    static let runID = UUID().uuidString
    
    func report(_ type: EventType, at point: Point, on currentScreen: String, in project: String, leadingTo destinationScreen: String? = nil) {
        let rpt = Report(action: type, currentScreen: currentScreen, destinationScreen: destinationScreen, positionX: Double(point.x), positionY: Double(point.y), projectId: project, runId: Telemetry.runID)
        
        let data = try! JSONEncoder().encode(rpt)
        var req = URLRequest(url: Telemetry.url)
        req.httpBody = data
        let task = URLSession.shared.dataTask(with: req)
        task.resume()
    }
}
