//
//  ViewController.swift
//  Mother
//
//  Created by Steve Sparks on 9/23/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pl()
    }

    func pl() {
        guard let img = UIImage(named: "pixo"), let data = img.pngData() else { return }
        let sq1uuid = UUID()
        let sq2 = Screen(uuid: UUID(), imageData: data, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 0, y: 0), size: Size(width: 100, height: 100)), target: sq1uuid, transition: .fromLeft, trigger: .tap),
            Hotspot(rect: Rect(origin: Point(x: 300, y: 0), size: Size(width: 100, height: 100)), target: sq1uuid, transition: .fromLeft, trigger: .tap)
        ])
        let sq1 = Screen(uuid: sq1uuid, imageData: data, hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 0, y: 0), size: Size(width: 100, height: 100)), target: sq2.uuid, transition: .fromRight, trigger: .tap),
            Hotspot(rect: Rect(origin: Point(x: 300, y: 0), size: Size(width: 100, height: 100)), target: sq2.uuid, transition: .fromRight, trigger: .tap)
        ])
        let project = Project(uuid: UUID(), name: "My Project", screens: [sq1, sq2])
        
        let json = try! JSONEncoder().encode(project)
        let str = String(data: json, encoding: .utf8)!
        print("\(str)")
    }
}

extension Screen {
    var image: UIImage? {
        return UIImage(data: imageData)
    }
}

