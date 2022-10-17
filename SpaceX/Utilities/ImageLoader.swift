//
//  ImageLoader.swift
//  SpaceX
//
//  Created by User on 10/17/22.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func fetch(_ urlString: String) async throws -> UIImage?
    func fetch(_ urlRequest: URLRequest) async throws -> UIImage?
}

actor ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    private init () { }
    private var images: [URLRequest: LoaderStatus] = [:]
    
    public func fetch(_ urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url)
        return try await fetch(request)
    }
    
    func fetch(_ urlRequest: URLRequest) async throws -> UIImage? {
        if let status = images[urlRequest] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        let task: Task<UIImage?, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
            let image = UIImage(data: imageData)
            return image
        }
        
        images[urlRequest] = .inProgress(task)
        let image = try await task.value
        images[urlRequest] = .fetched(image)
        return image
    }
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage?, Error>)
        case fetched(UIImage?)
    }
}

