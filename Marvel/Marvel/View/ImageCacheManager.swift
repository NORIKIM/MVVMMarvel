//
//  ImageCacheManager.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/30.
//

import UIKit

class ImageCacheManager: UIImageView {
    private var imageUrlString: String?
    private let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: ((Error?)-> Void)? = nil) {
        self.imageUrlString = url.absoluteString
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            completion?(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion?(error)
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    if (self.imageUrlString?.elementsEqual(url.absoluteString) ?? false) {
                        self.image = downloadedImage
                    }
                    
                    self.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                    completion?(nil)
                }
            }
        }.resume()
    }
}
