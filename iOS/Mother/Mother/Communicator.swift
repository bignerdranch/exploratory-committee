//
//  Communicator.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/24/20.
//

import UIKit
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
    static var sessionInactive = Notification.Name("sessionInactive")
    static var sessionDeactivated = Notification.Name("sessionDeactivated")
}

extension Communicator: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        NotificationCenter.default.post(name: .sessionInactive, object: session)
        print("WCSession did become inactive")

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NotificationCenter.default.post(name: .sessionDeactivated, object: session)
        print("WCSession did deactivate")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession error \(error)")
        }
        print("WCSession activation state = \(activationState.rawValue)")
        if activationState == .activated {
            if !session.isPaired {
                print("WCSession not paired")
            } else if session.isWatchAppInstalled {
                print("WCSession found the watch app")
                NotificationCenter.default.post(name: .sessionActivated, object: session)
            } else {
                print("WCSession did not find a watch app")
            }
            
        }
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("reeeaaach \(session.isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(message)
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        replyHandler(Data())
    }
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("file xfer complete")
        if let error = error {
            print("error! \(error)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watchkit context: \n\(applicationContext)")
    }
    
}

