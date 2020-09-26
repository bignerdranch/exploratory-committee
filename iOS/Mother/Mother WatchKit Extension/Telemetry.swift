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
    
    static func report(_ type: EventType, at point: Point, on currentScreen: String, in project: String, leadingTo destinationScreen: String? = nil) {
        print("Report")
        let rpt = Report(action: type, currentScreen: currentScreen, destinationScreen: destinationScreen, positionX: Double(point.x), positionY: Double(point.y), projectId: project, runId: Telemetry.runID)
        
        let data = try! JSONEncoder().encode(rpt)
        print("body > \(String(data: data, encoding: .utf8)!)")
        var req = URLRequest(url: Telemetry.url)
        req.httpBody = data
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: req) { dataOut, rsp, error in
            if let error = error {
                print("error! \(error)")
            }
            let ident = "\(arc4random() % 1000000)"
            print("\(req.logD(with: data, ident))")
            if let rsp = rsp as? HTTPURLResponse {
                print("\(rsp.logD(with: dataOut, ident))")
            }
        }
        task.resume()
    }
}

extension URLRequest {
    func logD(with data: Data?, _ ident: String = "") -> String {
        var ret = "---------REQUEST-\(ident)---------\n"
        let method = httpMethod!
        let url = self.url!
        ret.append("\(method) \(url)\n")
        for (key, val) in self.allHTTPHeaderFields ?? [:] {
            ret.append("\(key): \(val)\n")
        }
        if let data = data, let str = String(data: data, encoding: .utf8) {
            ret.append("\n")
            if str.count > 2000 {
                ret.append("\(str.prefix(1000))...")
            } else {
                ret.append(str)
            }
            ret.append("\n")
        }
        ret.append("---------REQUEST-\(ident)---------\n")

        return ret
    }
}

extension HTTPURLResponse {
    func logD(with data: Data?, _ ident: String = "") -> String {
        var ret = "---------RESPONSE-\(ident)---------\n"
        let code = self.statusCode
        let rsp = HTTPURLResponse.localizedString(forStatusCode: code)
        ret.append("\(code) \(rsp)\n")
        for (key, val) in self.allHeaderFields {
            ret.append("\(key): \(val)\n")
        }
        if let data = data, let str = String(data: data, encoding: .utf8) {
            ret.append("\n")
            if str.count > 2000 {
                ret.append("\(str.prefix(1000))...")
            } else {
                ret.append(str)
            }
            ret.append("\n")
        }
        ret.append("---------RESPONSE-\(ident)---------\n")
        return ret
    }
}
