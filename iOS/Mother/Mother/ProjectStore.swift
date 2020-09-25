//
//  ProjectStore.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/25/20.
//

import UIKit


class ProjectStore: NSObject {
    static let shared = ProjectStore()
    
    enum URLString: String {
        case fetch = "https://immense-bastion-45421.herokuapp.com/"
    }
    
    func url(for value: URLString) -> URL {
        return URL(string: value.rawValue)!
    }

    private var _projects = [Project]()
    var projects: [Project] { return _projects }
    
    func refresh(_ completion: @escaping ([Project], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url(for: .fetch)) { data, response, error in
            print("end task")
            if let error = error {
                print("Error! \(error)")
                completion([], error)
            } else if let data = data {
                do {
                    let projects = try JSONDecoder().decode(Array<Project>.self, from: data)
                    completion(projects, nil)
                } catch {
                    completion([], error)
                }
            }
        }
        print("starting task")
        task.resume()
    }
}
