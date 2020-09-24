//
//  InterfaceController.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/23/20.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}

class ScreenInterfaceController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var tapGestureRecognizer: WKTapGestureRecognizer!
    @IBOutlet weak var rightSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var upSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var longPressGestureRecognizer: WKLongPressGestureRecognizer!    
    @IBOutlet weak var downSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    
    
}
