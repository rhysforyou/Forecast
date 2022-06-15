//
//  ContentView.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

let locations: [Location] = [
    .init(
        name: "Sydney",
        latitude: -33.865143,
        longitude: 151.209900
    ),
    .init(
        name: "Melbourne",
        latitude: -37.840935,
        longitude: 144.946457
    ),
    .init(
        name: "San Francisco",
        latitude: 37.773972,
        longitude: -122.431297
    )
]

struct ContentView: View {
    @State private var selectedLocation: UUID? = locations.first?.id

    var body: some View {
        NavigationSplitView {
            List(locations, selection: $selectedLocation) { location in
                Label(location.name, systemImage: "location")
            }
            .navigationTitle("Locations")
            #if os(macOS)
            .frame(minWidth: 200)
            #endif
        } detail: {
            if let selectedLocation = locations.first(where: { $0.id == selectedLocation }) {
                LocationWeatherView(weatherRepository: WeatherRepository(location: selectedLocation))
            } else {
                Text("Select a location")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
