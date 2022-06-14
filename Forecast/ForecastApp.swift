//
//  ForecastApp.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

@main
struct ForecastApp: App {
    let weatherRepository = WeatherRepository()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(weatherRepository: weatherRepository)
            }
        }
    }
}
