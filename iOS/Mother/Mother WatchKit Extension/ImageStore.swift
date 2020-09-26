//
//  ImageStore.swift
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

class ScreenContainer {
    var screen: Screen
    var project: Project
    var isValid = false
    
    var image: UIImage?
    var hotspotImage: UIImage?
    
    init(_ screen: Screen, in project: Project, completion: @escaping (ScreenContainer) -> Void) {
        self.screen = screen
        self.project = project
        if let url = URL(string: screen.url) {
            ImageStore.shared.image(for: url) { imageOrNil in
                if let image = imageOrNil {
                    self.image = image
                    self.hotspotImage = self.hotspotImage(for: image)
                    self.isValid = true
                }
                completion(self)
            }
        }
    }

    var size: CGSize {
        if let img = self.image {
            return img.size
        }
        return .zero
    }
    
    func hotspotImage(for image: UIImage) -> UIImage? {
        let size = image.size
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setLineWidth(Hotspot.strokeWidth)
        context.setStrokeColor(Hotspot.strokeColor)
        context.setFillColor(Hotspot.fillColor)
        
        screen.hotspots?.forEach { $0.draw(into: context, for: size) }

        // Convert to UIImage
        let cgimage = context.makeImage();
        let uiimage = UIImage(cgImage: cgimage!)

        // End the graphics context
        UIGraphicsEndImageContext()

        // Show on WKInterfaceImage
        return uiimage
    }
}
