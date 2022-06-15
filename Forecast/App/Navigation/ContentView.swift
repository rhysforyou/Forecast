//
//  ContentView.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: ForecastModel
    @State var selectedLocation: Location.ID?

    var body: some View {
        NavigationSplitView {
            List(model.locations, selection: $selectedLocation) { location in
                Label(location.name, systemImage: "location")
            }
            .navigationTitle("Locations")
            #if os(macOS)
            .frame(minWidth: 200)
            #endif
        } detail: {
            if let selectedLocation {
                LocationWeatherView(locationID: selectedLocation)
            } else {
                Text("Select a location")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .environmentObject(model)
        .task { await model.updateForecasts() }
        .refreshable { await model.updateForecasts() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let model = ForecastModel()

    static var previews: some View {
        ContentView(model: model)
    }
}
