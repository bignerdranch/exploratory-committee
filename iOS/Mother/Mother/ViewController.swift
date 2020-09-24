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
        let project = Project.demoProject()
        let json = try! JSONEncoder().encode(project)
        let str = String(data: json, encoding: .utf8)!
        print("\(str)")
    }
}
