//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by User on 10/13/22.
//

import SwiftUI

@main
struct SpaceXApp: App {
    var body: some Scene {
        WindowGroup {
            AllEventsView(viewModel: .init())
        }
    }
}
