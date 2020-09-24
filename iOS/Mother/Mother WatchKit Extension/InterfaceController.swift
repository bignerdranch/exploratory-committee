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
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        pushController(withName: "screen", context: Project.demoProject().screens.first!)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}

