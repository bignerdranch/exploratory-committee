//
//  ProjectDetailViewController.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/25/20.
//

import UIKit

class ProjectDetailViewController: UITableViewController {
    enum Section: Int, CaseIterable {
        case detail, screens
    }
    enum DetailRow: Int, CaseIterable {
        case id, name, numberOfScreens
    }
    
    var screens = [Screen]()
    var project: Project? {
        didSet {
            if var p = project {
                p.sortScreens()
                screens = p.screens
            } else {
                screens = []
            }
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else { return nil }
        return sec.description
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        
        switch sec {
        case .detail:
            return DetailRow.allCases.count
        case .screens:
            return screens.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sec = Section(rawValue: indexPath.section) else { preconditionFailure("NEVER") }
        switch sec {
        case .detail: return 44
        case .screens: return 100
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else { preconditionFailure("NEVER") }
        
        switch sec {
        case .detail:
            let detail = DetailRow(rawValue: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic")!
            switch detail {
            case .name:
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = project?.name
            case .id:
                cell.textLabel?.text = "ID"
                cell.detailTextLabel?.text = project?._id
            case .numberOfScreens:
                cell.textLabel?.text = "Number of screens"
                cell.detailTextLabel?.text = "\(screens.count)"
            default: break
            }
            return cell
        case .screens:
            let cell = tableView.dequeueReusableCell(withIdentifier: "screen")!
            let screen = screens[indexPath.row]
            cell.textLabel?.text = screen.name
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = nil
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
            cell.accessoryView = iv
            if let url = URL(string: screen.url) {
                ImageStore.shared.image(for: url) { image in
                    DispatchQueue.main.async {
                        iv.image = image
                        iv.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
                        iv.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0, constant: -4.0).isActive = true
                    }
                }
            }
            return cell
        }

    }
    
    @IBAction func sendToWatch(_ sender: Any) {
        let alert = UIAlertController(title: "Send to Watch", message: "Are you sure you want the watch to display this project?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Send to Watch", style: .default, handler: { _ in
            self.reallySendToWatch()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func reallySendToWatch() {
        guard let prj = self.project else { return }
        Communicator.shared.transmitProject(prj) { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension ProjectDetailViewController.Section: CustomStringConvertible {
    var description: String {
        switch self {
        case .detail: return "Project Details"
        case .screens: return "Screens"
        }
    }
}
