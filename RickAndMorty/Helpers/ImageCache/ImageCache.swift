//
//  ImageCache.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 8/6/23.
//

import Foundation
import UIKit


final class ImageCache {
    private var cache = NSCache<NSString, UIImage>()
    static let shared = ImageCache()
    private init() { }
    
    // Get image from cache
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // Save image to cache
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
