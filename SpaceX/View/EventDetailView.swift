//
//  EventDetailView.swift
//  SpaceX
//
//  Created by User on 10/17/22.
//

import SwiftUI

struct EventDetailView: View {
    @ObservedObject var viewModel: EventsViewModel
    let flightBasicInfo: FlightBasicInfo
    @State var image: Image = Image("defaultImage")
    
    var body: some View {
        ScrollView {
            VStack {
                
                Text(flightBasicInfo.missionName)
                    .font(.largeTitle)
                
                ImageView(image: image)
                
                Divider()
                
                VStack(alignment: .leading) {
                    
                    InfoText(text: "Flight Number: \(flightBasicInfo.flightNumber)")
                    InfoText(text: "Rocket Name: \(flightBasicInfo.rocketName)")
                    InfoText(text: "Rocket Type: \(flightBasicInfo.rocketType)")
                    InfoText(text: "Site Name: \(flightBasicInfo.siteName)")
                    InfoText(text: "Date of Launch: \(flightBasicInfo.launchDate.toString)")
                    
                    InfoText(text: "Details: \(flightBasicInfo.details ?? "Not Provided")")
                    
                    if let reason = flightBasicInfo.failureReason {
                        InfoText(text: "Reason for failure: \(reason )")
                    }
                    
                }.padding(.leading, 10)
                
                Spacer()
            }.task {
                let downloadedImage = await viewModel.getPhotoFrom(url: flightBasicInfo.patchImageUrl)
                if let downloadedImage = downloadedImage {
                    image = Image(uiImage: downloadedImage)
                }
            }
        }
    }
}

struct InfoText: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .fontWeight(.thin)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(10)
            Divider()
        }
    }
}

struct ImageView: View {
    let image: Image
    
    var body: some View {
        
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
        
            .shadow(radius: 7)
            .padding(.vertical, 20)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(viewModel: EventsViewModel(), flightBasicInfo: FlightBasicInfo.info)
    }
}

extension FlightBasicInfo {
    static let info = FlightBasicInfo(id: 1,
                                      flightNumber: 1,
                                      missionName: "FalconSat",
                                      rocketName: "Falcon 1",
                                      rocketType: "falcon",
                                      siteName: "Kwajalein Atoll",
                                      launchDate: 1143239400,
                                      patchImageUrlSmall: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
                                      patchImageUrl: "https://images2.imgbox.com/40/e3/GypSkayF_o.png",
                                      details: "Engine failure at 33 seconds and loss of vehicle",
                                      failureReason: "merlin engine failure")
}
