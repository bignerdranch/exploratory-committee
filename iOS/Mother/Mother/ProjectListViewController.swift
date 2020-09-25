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
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didRequestRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refresh
        self.refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc @IBAction func didRequestRefresh(_ sender: Any) {
        print("refresh")
        refresh()
    }
    
    func refresh() {
        ProjectStore.shared.refresh { projects, error in
            if let error = error {
                print("Error! \(error)")
            } else if !projects.isEmpty {
                DispatchQueue.main.async {
                    self.projects = projects
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
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
        let btn = UIButton.systemButton(with: UIImage(systemName:"square.and.arrow.up")!, target: self, action: #selector(sendToWatch(_:)))
        btn.addTarget(self, action: #selector(sendToWatch(_:)), for: .touchUpInside)
        btn.tag = indexPath.row
        cell.accessoryView = btn
        return cell
    }
        
    @IBAction func sendToWatch(_ sender: UIButton) {
        let project = projects[sender.tag]
        let alert = UIAlertController(title: "Send to Watch", message: "Are you sure you want the watch to display this project?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Send to Watch", style: .default, handler: { _ in
            self.reallySendToWatch(project)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func reallySendToWatch(_ prj: Project) {
        Communicator.shared.transmitProject(prj) { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayProject", sender: self)
////        super.tableView(tableView, didSelectRowAt: indexPath)
//        let cell = tableView.cellForRow(at: indexPath)
//        let indicator = UIActivityIndicatorView()
//        cell?.accessoryView = indicator
//        indicator.startAnimating()
//
//        let project = projects[indexPath.row]
//        Communicator.shared.transmitProject(project, completion: { progress in
//            DispatchQueue.main.async {
//                let pView = UIProgressView(progressViewStyle: .bar)
//                cell?.accessoryView = pView
//                pView.observedProgress = progress
//            }
//        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let indexPath = tableView.indexPathForSelectedRow,
           let dest = segue.destination as? ProjectDetailViewController {
            let project = projects[indexPath.row]
            dest.project = project
        }
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
