//
//  ViewMode.swift
//  SpaceX
//
//  Created by User on 10/13/22.
//

import Foundation
import SwiftUI

@MainActor
class EventsViewModel: ObservableObject {
    @Published var flightsInfo: [FlightBasicInfo] = []
    let service = FlightDataService.shared
    let photoCacheManager = PhotoCacheManager.shared
    let imageLoader = ImageLoader.shared
    
    func loadAllFlights() async {
        do {
            flightsInfo =  try  await service.getAllFlights() ?? []
        } catch let error {
            print("View Model --------- Error loadingAllFlights \(error)")
        }
    }
    
    
    func getPhotoFrom(url : String?) async  -> UIImage? {
        guard let url = url else { return nil }
        // Look for the image in the cache
        if let savedPhoto = photoCacheManager.getPhoto(forKey: url) {
            return savedPhoto
        } else {
            // Download Image using ImageLoader
            guard let image =  try? await self.imageLoader.fetch(url) else { return nil }
            photoCacheManager.addPhoto(forKey: url, value: image)
            return image
        }
    }
}
