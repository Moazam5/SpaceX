//
//  Service.swift
//  SpaceX
//
//  Created by User on 10/13/22.
//

import Foundation

protocol FlightServiceProtocol {
    func getAllFlights() async throws -> [FlightBasicInfo]?
}

struct FlightDataService: FlightServiceProtocol {
    
    private static let endpoint = "https://api.spacexdata.com/v3/launches"
    static let shared = FlightDataService()
    
    private init() {}
    
    func getAllFlights() async throws -> [FlightBasicInfo]? {
        guard let url = URL(string: Self.endpoint) else { return  nil }
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        do {
            let resource = try decoder.decode([FlightObject].self, from: data)
            let flightResource = FlightBasicInfoResource(resource)
            return flightResource.info
        } catch {
            print("FlightService -------- Error decoding data \(error)")
        }
        return nil
    }
}



