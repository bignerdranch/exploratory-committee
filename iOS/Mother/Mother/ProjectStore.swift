//
//  ProjectStore.swift
//  Geoffrey
//
//  Created by Steve Sparks on 9/25/20.
//

import UIKit


class ImageStore: NSObject {
    var images = [URL: UIImage]()
    static var shared = ImageStore()
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let img = images[url] {
            completion(img)
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    self.images[url] = image
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        }
    }
}

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
                    let newProjects = try JSONDecoder().decode(Array<Project>.self, from: data)
                    completion(newProjects, nil)
                } catch {
                    completion([], error)
                }
            }
        }
        print("starting task")
        task.resume()
    }
}

extension Project {
    static func demoProject() -> Project {
        guard let img1 = UIImage(named: "Option 1 - Screen 0"), let data1 = img1.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img2 = UIImage(named: "Option 1 - Screen 1"), let data2 = img2.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img3 = UIImage(named: "Option 1 - Screen 2"), let data3 = img3.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img4 = UIImage(named: "Option 1 - Screen 3"), let data4 = img4.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img5 = UIImage(named: "Option 1 - Screen 4"), let data5 = img5.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img6 = UIImage(named: "Option 1 - Screen 5"), let data6 = img6.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img7 = UIImage(named: "Option 1 - Screen 6"), let data7 = img7.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        guard let img8 = UIImage(named: "Option 1 - Screen 7"), let data8 = img8.pngData() else { preconditionFailure("this wasn't supposed to end this way") }
        let sq1uuid = UUID().uuidString
        let sq2uuid = UUID().uuidString
        let sq3uuid = UUID().uuidString
        let sq4uuid = UUID().uuidString
        let sq5uuid = UUID().uuidString
        let sq6uuid = UUID().uuidString
        let sq7uuid = UUID().uuidString
        let sq8uuid = UUID().uuidString

        let wholeScreen = Rect(origin: Point(x: 0, y: 0), size: Size(width: 368, height: 448))
        
        let sq1 = Screen(uuid: sq1uuid, url: "", name: "", hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 130), size: Size(width: 360, height: 100)), target: sq2uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq2 = Screen(uuid: sq2uuid, url: "", name: "", hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 240), size: Size(width: 360, height: 90)), target: sq3uuid, transition: .fromLeft, trigger: .tap),
        ])
        let sq3 = Screen(uuid: sq3uuid, url: "", name: "", hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 460), size: Size(width: 360, height: 100)), target: sq4uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq4 = Screen(uuid: sq4uuid, url: "", name: "", hotspots: [
            Hotspot(rect: Rect(origin: Point(x: 10, y: 140), size: Size(width: 340, height: 140)), target: sq5uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq5 = Screen(uuid: sq5uuid, url: "", name: "", hotspots: [
            Hotspot(rect: wholeScreen, target: sq6uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq6 = Screen(uuid: sq6uuid, url: "", name: "", hotspots: [
            Hotspot(rect: wholeScreen, target: sq7uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq7 = Screen(uuid: sq7uuid, url: "", name: "", hotspots: [
            Hotspot(rect: wholeScreen, target: sq8uuid, transition: .fromRight, trigger: .tap),
        ])
        let sq8 = Screen(uuid: sq8uuid, url: "", name: "", hotspots: [
            Hotspot(rect: wholeScreen, target: sq1uuid, transition: .fromRight, trigger: .tap),
        ])
        let url = URL(string: "https://www.google.com/")!
        let project = Project(_id: UUID().uuidString, name: "My Project", url: url, screens: [sq1, sq2, sq3, sq4, sq5, sq6, sq7, sq8])
        return project
    }
}
