//
//  ContentView.swift
//  SpaceX
//
//  Created by User on 10/13/22.
//

import SwiftUI

struct AllEventsView: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                FlightsBasicInfoView(flightsInfo: viewModel.flightsInfo, viewModel: viewModel)
            }.task {
                await self.viewModel.loadAllFlights()
            }
            .navigationTitle("All Historic Events")
        }
    }
}

struct FlightsBasicInfoView: View {
    let flightsInfo: [FlightBasicInfo]
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        if flightsInfo.count > 0 {
            List {
                ForEach(flightsInfo) { info in
                    NavigationLink {
                        EventDetailView(viewModel: viewModel, flightBasicInfo: info)
                    } label: {
                        FlightBasicInfoCell(flightBasicInfo: info,
                                            viewModel: viewModel)
                    }
                }
            }
        } else {
            ProgressView()
        }
    }
}

struct FlightBasicInfoCell: View {
    let flightBasicInfo: FlightBasicInfo
    @ObservedObject var viewModel: EventsViewModel
    @State private var thumbnailImage: Image = Image("defaultImage")
    
    var body: some View {
        HStack(alignment: .center) {
            thumbnailImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)
                .foregroundColor(.black)
            
            VStack(alignment: .leading) {
                Text(flightBasicInfo.missionName)
                    .font(.title)
                
                Text("Rocket Name: \(flightBasicInfo.rocketName)")
                    .font(.callout)
                Text("Site Name: \(flightBasicInfo.siteName)")
                Text("Launch Time: \(flightBasicInfo.launchDate.toString)")
            }
        }
        .task {
            let image = await viewModel.getPhotoFrom(url: flightBasicInfo.patchImageUrlSmall)
            if let image = image {
                thumbnailImage = Image(uiImage: image)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllEventsView(viewModel: EventsViewModel())
    }
}


extension Int64 {
    var toString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
