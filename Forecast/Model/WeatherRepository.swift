//
//  WeatherRepository.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import Foundation
import SwiftUI
import WeatherKit
import CoreLocation
import os

extension Logger {
    static var weatherRepository: Logger {
        Logger(subsystem: "Forecast", category: "WeatherRepository")
    }
}

final class WeatherRepository: ObservableObject {
    private let weatherService: WeatherService

    let location: Location

    @Published var currentWeather: CurrentWeather?
    @Published var hourlyForecast: Forecast<HourWeather>?

    init(weatherService: WeatherService = .shared, location: Location = .sydney) {
        self.weatherService = weatherService
        self.location = location
    }

    @MainActor func fetchWeather() async {
        do {
            (currentWeather, hourlyForecast) = try await weatherService.weather(for: location.clLocation, including: .current, .hourly)
        } catch {
            Logger.weatherRepository.error("Unable to fetch weather: \(error)")
        }
    }
}

