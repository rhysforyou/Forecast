//
//  LocationWeather.swift
//  Forecast
//
//  Created by Rhys Powell on 15/6/2022.
//

import Foundation
import WeatherKit

struct LocationWeather: Sendable {
    let temperature: Measurement<UnitTemperature>
    let condition: String
    let symbolName: String
    let isDaylight: Bool
    let hourlyForecast: [HourlyWeather]

    var temperatureUnit: UnitTemperature {
        temperature.unit
    }

    var binRange: ClosedRange<Date> {
        let startDate = hourlyForecast.map(\.date).first { date in
            Calendar.current.component(.hour, from: date).isMultiple(of: 3)
        }

        let endDate = hourlyForecast.map(\.date).reversed().first { date in
            Calendar.current.component(.hour, from: date).isMultiple(of: 3)
        }

        return startDate! ... endDate!
    }

    var low: Measurement<UnitTemperature> {
        let min = hourlyForecast.map(\.temperature).min() ?? temperature
        return min - Measurement<UnitTemperature>(value: 2, unit: min.unit)
    }
}

extension LocationWeather {
    init(currentWeather: CurrentWeather, hourlyForecast: Forecast<HourWeather>) {
        self.temperature = currentWeather.temperature
        self.condition = currentWeather.condition.description
        self.symbolName = currentWeather.symbolName
        self.isDaylight = currentWeather.isDaylight
        self.hourlyForecast = hourlyForecast.forecast.map(HourlyWeather.init)
    }
}
