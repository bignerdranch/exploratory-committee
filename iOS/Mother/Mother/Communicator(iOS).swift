//
//  Communicator.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/24/20.
//

import UIKit
import WatchConnectivity

class Communicator: NSObject {
    var logEntries = [String]()
    
    static var shared = Communicator()

    var session: WCSession!
    
    override init() {
        super.init()
        self.session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    func log(_ message: String) {
        NotificationCenter.default.post(name: .watchLogEntry, object: message)
    }
}

extension Notification.Name {
    static var newProjectReceived = Notification.Name("newProjectReceived")
    static var sessionActivated = Notification.Name("sessionActivated")
    static var sessionInactive = Notification.Name("sessionInactive")
    static var sessionDeactivated = Notification.Name("sessionDeactivated")

    static var watchLogEntry = Notification.Name("watchLogEntry")
}

extension Communicator: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        NotificationCenter.default.post(name: .sessionInactive, object: session)
        logMessage("WCSession did become inactive")

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NotificationCenter.default.post(name: .sessionDeactivated, object: session)
        logMessage("WCSession did deactivate")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            logMessage("WCSession error \(error)")
        }
        logMessage("WCSession activation state = \(activationState.rawValue)")
        if activationState == .activated {
            if !session.isPaired {
                logMessage("WCSession not paired")
            } else if session.isWatchAppInstalled {
                logMessage("WCSession found the watch app")
                NotificationCenter.default.post(name: .sessionActivated, object: session)
            } else {
                logMessage("WCSession did not find a watch app")
            }
            
        }
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        logMessage("Reachability changed: \(session.isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        logMessage("Received message \(message.description)")
        replyHandler(message)
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        logMessage("Received messageData, \(messageData.count) bytes")
        replyHandler(Data())
        
    }
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        let file = fileTransfer.file.fileURL
        
        logMessage("Finished sending file at \(file)")
        try? FileManager.default.removeItem(at: file)
        if let error = error {
            logMessage("error! \(error)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        logMessage("Watchkit context: \n\(applicationContext)")
    }
 
    func logMessage(_ message: String) {
        print("WatchComm: \(message)")
        logEntries.append(("WatchComm: \(message)"))
        log(message)
    }
    
    func transmitProject(_ project: Project, completion: @escaping (Progress) -> Void) {
        logMessage("Transmitting project")
        session.sendMessage(["newProject":project.uuid.uuidString], replyHandler: { response in
            if let uuid = response["send"] as? String,
               uuid == project.uuid.uuidString {
                completion(self.sendProjectAsFile(project))
            }
        }, errorHandler: { error in
            self.logMessage("Received error \(error)")
        })
        
    }

    func sendProjectAsFile(_ project: Project) -> Progress {
        logMessage("Transmitting project file")
        let jsonData = try! JSONEncoder().encode(project)
        let tempDir = session.watchDirectoryURL ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let file = URL(fileURLWithPath: tempDir.appendingPathComponent("\(UUID().uuidString).json").path)
        print("\n\n\(jsonData.count) bytes\n\(file.absoluteURL)\n\n")
        
        try! jsonData.write(to: file.absoluteURL)
        
        logMessage("Sending file at \(file)")
        let xfer = session.transferFile(file, metadata: nil)
        
        return xfer.progress
    }
}

