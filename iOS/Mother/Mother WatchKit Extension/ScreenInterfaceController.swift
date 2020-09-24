//
//  ScreenInterfaceController.swift
//  Mother WatchKit Extension
//
//  Created by Steve Sparks on 9/24/20.
//

import WatchKit
import Foundation
import WatchConnectivity

extension CGPoint {
    func point(with scale: CGFloat) -> Point {
        return Point(x: Double(x * scale), y: Double(y * scale))
    }
}
extension Rect {
    func contains(_ point: Point) -> Bool {
        return
            point.x > origin.x && point.x < (origin.x + size.width) &&
            point.y > origin.y && point.y < (origin.y + size.height)
    }
}
extension Point: CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}
extension Screen {
    func hitTest(for point: Point) -> Hotspot? {
        for hotspot in hotspots {
            if hotspot.rect.contains(point) {
                return hotspot
            }
        }
        return nil
    }
}

class ScreenInterfaceController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var group: WKInterfaceGroup!
    @IBOutlet weak var tapGestureRecognizer: WKTapGestureRecognizer!
    @IBOutlet weak var rightSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var upSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var longPressGestureRecognizer: WKLongPressGestureRecognizer!
    @IBOutlet weak var downSwipeGestureRecognizer: WKSwipeGestureRecognizer!

    var transitioningTo: Hotspot?
    
    var screen: Screen? {
        didSet {
            image.setImage(screen?.hotspotImage)
            group.setBackgroundImage(screen?.image)
            image.setAlpha(0.0)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake")

        if let screen = context as? Screen {
            self.screen = screen
        } else if let project = context as? Project{
            self.screen = project.screens.first!
        } else {
            print("ctx")
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let uuid = self.screen?.uuid {
            Communicator.report(.present, message: uuid.uuidString)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        if let hotspot = transitioningTo {
            print("moving to hotspot \(hotspot)")
        } else {
            Communicator.report(.back)
        }
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
        let scale: CGFloat = WKInterfaceDevice.current().screenScale
        let point =  sender.locationInObject().point(with: scale)
        print("tap \(point)")
        
        Communicator.report(.tap, message: point.description)
        
        if let hotspot = screen?.hitTest(for: point), hotspot.trigger == .tap {
            transition(to: hotspot, in: Communicator.shared.currentProject!)
        } else {
            flashHotspots()
        }
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
        let scale: CGFloat = WKInterfaceDevice.current().screenScale
        let point =  sender.locationInObject().point(with: scale)

        let typ: ReportType = sender.state == .ended ? .longPressEnded : .longPressRecognized
        // TODO calculate time of press
        Communicator.report(typ, message: point.description)

        if let hotspot = screen?.hitTest(for: point), hotspot.trigger == .longPress {
            transitioningTo = hotspot
            transition(to: hotspot, in: Communicator.shared.currentProject!)
        } else {
            flashHotspots()
        }
    }
    
    func transition(to hotspot: Hotspot, in project: Project) {
        transitioningTo = hotspot
        guard let screen = project.screen(with: hotspot.target) else {
            NSLog("Error: no screen in project with ID \(hotspot.target.uuidString)")
            return
        }
        switch hotspot.transition {
        case .fromLeft:
            pushController(withName: "screen", context: screen)
            break
        case .fromRight:
            pushController(withName: "screen", context: screen)
            break
        case .fromTop:
            break
        case .fromBottom:
            break
        case .fade:
            break
        case .instant:
            break
        }
    }
    
    override func pop() {
        super.pop()
        print("pop")
    }
}
