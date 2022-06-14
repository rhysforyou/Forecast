//
//  HourlyForecast.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import Foundation
import WeatherKit

struct HourlyForecast {
    let forecast: Forecast<HourWeather>

    var hourlyWeather: [HourWeather] {
        forecast.forecast
    }

    var temperatureUnit: UnitTemperature {
        hourlyWeather.first?.temperature.unit ?? UnitTemperature(forLocale: .current)
    }

    var binRange: ClosedRange<Date> {
        let startDate = hourlyWeather.map(\.date).first { date in
            Calendar.current.component(.hour, from: date).isMultiple(of: 3)
        }

        let endDate = hourlyWeather.map(\.date).reversed().first { date in
            Calendar.current.component(.hour, from: date).isMultiple(of: 3)
        }

        return startDate! ... endDate!
    }
}
