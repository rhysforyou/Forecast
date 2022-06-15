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
    let hourlyForecast: [HourlyForecast]

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
}
