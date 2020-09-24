//
//  AppDelegate.swift
//  Mother
//
//  Created by Steve Sparks on 9/23/20.
//

import UIKit
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let session = WCSession.default

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        session.delegate = self
        session.activate()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("deactivate")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("error \(error)")
        }
        print("state \(activationState.rawValue)")
        
        if activationState == .activated {
            let project = Project.demoProject()
            let jsonData = try! JSONEncoder().encode(project)
            
            let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let file = tempDir.appendingPathComponent("\(UUID().uuidString).json")
            try! jsonData.write(to: file)
            
            print("sending file")
            session.transferFile(file, metadata: nil)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {

    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("file xfer complete")
        if let error = error {
            print("error! \(error)")
        }
    }
    
}
