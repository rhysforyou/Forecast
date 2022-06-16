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

extension LocationWeather {
    private static func placeholderHourlyWeather(hourOffset: Int, degrees: Double, isDaylight: Bool, condition: String, symbolName: String) -> HourlyWeather {
        HourlyWeather(
            date: Date().addingTimeInterval(TimeInterval(hourOffset) * 60 * 60),
            temperature: Measurement<UnitTemperature>(value: degrees, unit: .fahrenheit),
            isDaylight: isDaylight,
            condition: condition,
            symbolName: symbolName
        )
    }

    static var placeholderWeather: LocationWeather {
        return LocationWeather(
            temperature: Measurement(value: 20, unit: .celsius),
            condition: "Cloudy",
            symbolName: "cloud",
            isDaylight: true,
            hourlyForecast: [
                placeholderHourlyWeather(hourOffset: 0, degrees: 63, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 1, degrees: 68, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 2, degrees: 72, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 3, degrees: 77, isDaylight: true, condition: "Rain", symbolName: "cloud.rain"),
                placeholderHourlyWeather(hourOffset: 4, degrees: 80, isDaylight: true, condition: "Rain", symbolName: "cloud.rain"),
                placeholderHourlyWeather(hourOffset: 5, degrees: 82, isDaylight: true, condition: "Rain", symbolName: "cloud.rain"),
                placeholderHourlyWeather(hourOffset: 6, degrees: 83, isDaylight: true, condition: "Rain", symbolName: "cloud.rain"),
                placeholderHourlyWeather(hourOffset: 7, degrees: 83, isDaylight: true, condition: "Light Showers", symbolName: "cloud.drizzle"),
                placeholderHourlyWeather(hourOffset: 8, degrees: 81, isDaylight: true, condition: "Light Showers", symbolName: "cloud.drizzle"),
                placeholderHourlyWeather(hourOffset: 9, degrees: 79, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 10, degrees: 75, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 11, degrees: 70, isDaylight: true, condition: "Cloudy", symbolName: "cloud"),
                placeholderHourlyWeather(hourOffset: 12, degrees: 66, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 13, degrees: 64, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 14, degrees: 63, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 15, degrees: 61, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 16, degrees: 60, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 17, degrees: 59, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 18, degrees: 57, isDaylight: false, condition: "Sunny", symbolName: "sun.max"),
                placeholderHourlyWeather(hourOffset: 19, degrees: 56, isDaylight: false, condition: "Clear", symbolName: "moon.stars"),
                placeholderHourlyWeather(hourOffset: 20, degrees: 55, isDaylight: false, condition: "Clear", symbolName: "moon.stars"),
                placeholderHourlyWeather(hourOffset: 21, degrees: 55, isDaylight: true, condition: "Clear", symbolName: "moon.stars"),
                placeholderHourlyWeather(hourOffset: 22, degrees: 56, isDaylight: true, condition: "Clear", symbolName: "moon.stars"),
                placeholderHourlyWeather(hourOffset: 23, degrees: 59, isDaylight: true, condition: "Clear", symbolName: "moon.stars"),
                placeholderHourlyWeather(hourOffset: 24, degrees: 62, isDaylight: true, condition: "Clear", symbolName: "moon.stars"),
            ])
    }
}
