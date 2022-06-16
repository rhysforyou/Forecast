//
//  ContentView.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: ForecastModel
    @State var selection: Location.ID?

    var body: some View {
        NavigationSplitView {
            List(model.locations, selection: $selection) { location in
                NavigationLink(value: location.id) {
                    Label(location.name, systemImage: "location")
                }
            }
            .navigationTitle("Locations")
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
            #endif
        } detail: {
            // The first beta of iOS/iPadOS 16 has a bug where conditionally updating the contents of a NavigationSplitView's detail column doesn't work. The temporary solution is to wrap the contents in a ZStack
            ZStack {
                if let selection {
                    LocationWeatherView(locationID: selection)
                } else {
                    Text("Select a location")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
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
