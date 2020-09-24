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
}

extension Notification.Name {
    static var newProjectReceived = Notification.Name("newProjectReceived")
    static var sessionActivated = Notification.Name("sessionActivated")
}

extension Communicator: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("error \(error)")
        }
        if activationState == .activated {
            NotificationCenter.default.post(name: .sessionActivated, object: session)
        }
        print("--- state \(activationState.rawValue)")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        if let project = try? JSONDecoder().decode(Project.self, from: messageData) {
            print("got project")
            NotificationCenter.default.post(name: .newProjectReceived, object: project)
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("file!")
        if let data = try? Data(contentsOf: file.fileURL),
           let project = try? JSONDecoder().decode(Project.self, from: data) {
            print("got project")
            NotificationCenter.default.post(name: .newProjectReceived, object: project)
        }
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("xfer")
        if let error = error {
            print("error! \(error)")
        }
    }
}
