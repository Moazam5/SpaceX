//
//  PhotoCacheManager.swift
//  SpaceX
//
//  Created by User on 10/17/22.
//

import Foundation
import SwiftUI

class PhotoCacheManager {
    static let shared = PhotoCacheManager()
    private init() { }
    
    var photoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func addPhoto(forKey key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func getPhoto(forKey key: String) -> UIImage? {
        return photoCache.object(forKey: key as NSString)
    }
}
