//
//  FlightInfo.swift
//  SpaceX
//
//  Created by User on 10/13/22.
//

import Foundation

struct FlightBasicInfo {
    let id: Int
    let flightNumber: Int
    let missionName: String
    let rocketName: String
    let rocketType: String
    let siteName: String
    let launchDate: Int64
    let patchImageUrlSmall: String?
    let patchImageUrl: String?
    let details: String?
    let failureReason: String?
}

extension FlightBasicInfo: Identifiable {}

struct FlightObject: Codable {
    let flight_number: Int
    let mission_name: String
    let launch_date_unix: Int64
    let rocket: Rocket
    let launch_site: LaunchSite
    let links: Links
    let details: String?
    let launch_failure_details: LaunchFailureDetails?

    
    struct Rocket: Codable {
        let rocket_name: String
        let rocket_type: String
    }
    
    struct LaunchSite: Codable {
        let site_name: String
    }
    
    struct Links: Codable {
        let mission_patch: String?
        let mission_patch_small: String?
    }
    
    struct LaunchFailureDetails: Codable {
        let reason: String?
    }
}

struct FlightBasicInfoResource: Codable {

    let flight: [FlightObject]

    var info: [FlightBasicInfo] {
        return flight.compactMap { FlightBasicInfo(
            id: $0.flight_number,
            flightNumber: $0.flight_number,
            missionName: $0.mission_name,
            rocketName: $0.rocket.rocket_name,
            rocketType: $0.rocket.rocket_type,
            siteName: $0.launch_site.site_name,
            launchDate: $0.launch_date_unix,
            patchImageUrlSmall: $0.links.mission_patch_small,
            patchImageUrl: $0.links.mission_patch,
            details: $0.details,
            failureReason: $0.launch_failure_details?.reason)
        }
    }
    
    init(_ flight: [FlightObject]) {
        self.flight = flight
    }
}
