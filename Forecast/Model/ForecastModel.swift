//
//  ForecastModel.swift
//  Forecast
//
//  Created by Rhys Powell on 15/6/2022.
//

import SwiftUI
import WeatherKit

extension LocationWeather {
    init(currentWeather: CurrentWeather, hourlyForecast: Forecast<HourWeather>) {
        self.temperature = currentWeather.temperature
        self.condition = currentWeather.condition.description
        self.symbolName = currentWeather.symbolName
        self.isDaylight = currentWeather.isDaylight
        self.hourlyForecast = hourlyForecast.forecast.map(HourlyForecast.init)
    }
}

/// A representation of the application state
@MainActor
class ForecastModel: ObservableObject {
    @Published var locations: [Location]
    @Published var weatherByLocation: [Location.ID: LocationWeather] = [:]

    init() {
        self.locations = [
            .init(
                name: "Wollongong",
                latitude: -34.425072,
                longitude: 150.893143
            ),
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
    }

    func updateForecasts() async {
        do {
            weatherByLocation = try await withThrowingTaskGroup(of: (Location.ID, LocationWeather).self, body: { taskGroup in
                for location in locations {
                    taskGroup.addTask {
                        let (current, hourly) = try await WeatherService.shared.weather(for: location.clLocation, including: .current, .hourly)
                        let forecast = LocationWeather(currentWeather: current, hourlyForecast: hourly)
                        return (location.id, forecast)
                    }
                }

                var forecastByLocation: [Location.ID: LocationWeather] = [:]
                for try await (id, forecast) in taskGroup {
                    forecastByLocation[id] = forecast
                }

                return forecastByLocation
            })
        } catch {
            print("Unable to update forecasts: \(error.localizedDescription)")
        }
    }

    func location(for id: Location.ID) -> Location? {
        locations.first(where: { $0.id == id })
    }

    func weather(for locationID: Location.ID) -> LocationWeather? {
        weatherByLocation[locationID]
    }
}
