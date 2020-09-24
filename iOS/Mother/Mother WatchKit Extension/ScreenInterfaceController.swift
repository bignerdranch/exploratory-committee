//
//  ScreenInterfaceController.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/24/20.
//

import WatchKit
import Foundation


class ScreenInterfaceController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var group: WKInterfaceGroup!
    @IBOutlet weak var tapGestureRecognizer: WKTapGestureRecognizer!
    @IBOutlet weak var rightSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var upSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var longPressGestureRecognizer: WKLongPressGestureRecognizer!
    @IBOutlet weak var downSwipeGestureRecognizer: WKSwipeGestureRecognizer!

    var screen: Screen? {
        didSet {
            image.setImage(screen?.hotspotImage)
            group.setBackgroundImage(screen?.image)
            image.setAlpha(0.0)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let screen = context as? Screen {
            self.screen = screen
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func flashHotspots() {
        animate(withDuration: 0.3) {
            self.image.setAlpha(1.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animate(withDuration: 0.3) {
                self.image.setAlpha(0.0)
            }
        }
    }

    
    @IBAction func didTap(_ sender: WKTapGestureRecognizer) {
        
        print("tap")
        flashHotspots()
    }
    
    @IBAction func didSwipeRight(_ sender: WKSwipeGestureRecognizer) {
        print("swipe")

    }
    @IBAction func didSwipeLeft(_ sender: WKSwipeGestureRecognizer) {
        print("swipe")

    }
    @IBAction func didSwipeUp(_ sender: WKSwipeGestureRecognizer) {
        print("swipe")

    }
    @IBAction func didSwipeDown(_ sender: WKSwipeGestureRecognizer) {
        print("swipe")

    }
    @IBAction func didLongPress(_ sender: WKLongPressGestureRecognizer) {
        print("longpress")

    }
}
