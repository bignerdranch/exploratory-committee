//
//  InterfaceController.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/23/20.
//

import WatchKit
import Foundation


class RootInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        let session = Communicator.shared.session
        // Configure interface objects here.
        NotificationCenter.default.addObserver(forName: .newProjectReceived, object: nil, queue: .main) { note in
            if let prj = note.object as? Project {
                self.popToRootController()
                self.pushController(withName: "screen", context: prj)
            }
        }
        NotificationCenter.default.addObserver(forName: .sessionActivated, object: nil, queue: .main) { note in
            session?.sendMessage(["Hello":"Hello"], replyHandler: { _ in }, errorHandler: { print("Error! \($0)") })
        }
        print("Observer added.")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("pushing")
        self.pushController(withName: "project", context: Project.demoProject())

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible


    }

}

