//
//  WatchLogViewController.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/24/20.
//

import UIKit

class WatchLogViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .watchLogEntry, object: nil, queue: .main) { [weak self] note in
            guard let self = self else { return }
            if let msg = note.object as? String {
                self.textView.text = self.textView.text + "\n" + msg
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
