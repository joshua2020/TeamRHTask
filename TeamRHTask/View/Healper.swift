//
//  Healper.swift
//  TeamRHTask
//
//  Created by Joshua on 31/03/2022.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)

    func loadImage(from url: URL) {
        image = nil
        addSpinner()
        
        if let task = task {
        task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let newImage = UIImage(data: data)
            else  {
                print("Could not load image from URL: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
        }
        task.resume()
    }

    func addSpinner() {
        addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }

    func removeSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
