//
//  ProjectListViewController.swift
//  Mother
//
//  Created by Steve Sparks on 9/24/20.
//

import UIKit
import WatchConnectivity

class ProjectListViewController: UITableViewController {
    var projects: [Project] = [.demoProject()]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        let project = projects[indexPath.row]
        
        cell.textLabel?.text = project.name
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        super.tableView(tableView, didSelectRowAt: indexPath)
        let project = projects[indexPath.row]
        let progress = transmitProject(project)
        
        let cell = tableView.cellForRow(at: indexPath)
        let pView = UIProgressView(progressViewStyle: .bar)
        cell?.accessoryView = pView
        pView.observedProgress = progress
    }
    
    func transmitProject(_ project: Project) -> Progress {
        let session = WCSession.default
        session.transferUserInfo(["currentProject":"\(project.uuid.uuidString)"])
        
        session.sendMessage(["newProject":project.uuid], replyHandler: { response in
            print("\(response)")
        }, errorHandler: { error in
            print("\(error)")
        })
        
        let jsonData = try! JSONEncoder().encode(project)
        
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let file = tempDir.appendingPathComponent("\(UUID().uuidString).json")
        try! jsonData.write(to: file)
        
        print("sending file")
        let xfer = session.transferFile(file, metadata: nil)
        return xfer.progress        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
