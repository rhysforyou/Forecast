//
//  HourlyForecast.swift
//  Forecast
//
//  Created by Rhys Powell on 15/6/2022.
//

import Foundation
import WeatherKit

struct HourlyWeather: Sendable {
    let date: Date
    let temperature: Measurement<UnitTemperature>
    let isDaylight: Bool
}

extension HourlyWeather {
    init(hour: HourWeather) {
        self.date = hour.date
        self.temperature = hour.temperature
        self.isDaylight = hour.isDaylight
    }
}