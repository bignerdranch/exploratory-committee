//
//  Communicator.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/24/20.
//

import WatchKit
import WatchConnectivity

class Communicator: NSObject {
    static var shared = Communicator()

    var session: WCSession!
    
    override init() {
        super.init()
        self.session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    var currentProject: Project? 

}

extension Notification.Name {
    static var newProjectReceived = Notification.Name("newProjectReceived")
    static var sessionActivated = Notification.Name("sessionActivated")
}

extension Communicator: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error \(error)")
        }
        print("WCSession activation state = \(activationState.rawValue)")
        if activationState == .activated {
            NotificationCenter.default.post(name: .sessionActivated, object: session)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession reachability change: isReachable = \(session.isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("WCSession received message data")
        if let project = try? JSONDecoder().decode(Project.self, from: messageData) {
            print("WCSession got project")
            NotificationCenter.default.post(name: .newProjectReceived, object: project)
        }
        replyHandler(Data())
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("WCSession received message \(message)")
        if let newProjectId = message["newProject"],
           let data = message["jsonData"] as? Data {
            let project = try! JSONDecoder().decode(Project.self, from: data) 
            replyHandler(["ack":newProjectId])
            currentProject = project
            NotificationCenter.default.post(name: .newProjectReceived, object: project)
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("WCSession received file \(file)")
        if let data = try? Data(contentsOf: file.fileURL),
           let project = try? JSONDecoder().decode(Project.self, from: data) {
            print("WCSession got project")
            NotificationCenter.default.post(name: .newProjectReceived, object: project)
        }
    }
        
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("WCSession finished transfer \(fileTransfer)")
        if let error = error {
            print("error! \(error)")
        }
    }
    
    func sessionCompanionAppInstalledDidChange(_ session: WCSession) {
        print("companion app changed")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("WCSession received context \(applicationContext)")
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("WCSession received userInfo \(userInfo)")
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        print("WCSession finished xferring userInfo \(userInfoTransfer.userInfo)")
    }
}

enum ReportType: String {
    case tap
    case longPressRecognized
    case longPressEnded
    case back
    case hint
    case present
    case swipeRight, swipeLeft, swipeUp, swipeDown
}

extension Communicator {
    static func report(_ type: ReportType, message: String = "", replyHandler: (([String:Any]) -> Void)? = nil) {
        shared.session.sendMessage([type.rawValue:message, "date": Date().timeIntervalSince1970], replyHandler: {
            if let handler = replyHandler {
                handler($0)
            }
        }, errorHandler: { print("WCSession error \($0)") })
    }
}
