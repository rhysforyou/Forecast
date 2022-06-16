//
//  HourlyForecastChart.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI
import WeatherKit
import Charts

struct HourlyForecastChart: View {
    let weather: LocationWeather

    var body: some View {
        Chart(weather.hourlyForecast, id: \.date) { hour in
            AreaMark(
                x: .value("Date", hour.date),
                yStart: .value("Temperature", weather.low.value),
                yEnd: .value("Temperatuer", hour.temperature.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                hour.isDaylight
                ? Color.accentColor.gradient.opacity(0.5)
                : Color.blue.gradient.opacity(0.5)
            )
            
            LineMark(
                x: .value("Date", hour.date),
                y: .value("Temperature", hour.temperature.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                hour.isDaylight
                ? Color.accentColor.gradient
                : Color.blue.gradient
            )
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartYAxis {
            AxisMarks(values: .automatic(minimumStride: 5, desiredCount: 6, roundLowerBound: false)) { value in
                AxisValueLabel("\(value.as(Double.self)!.formatted())\(weather.temperatureUnit.symbol)")
                AxisTick()
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(values: DateBins(unit: .hour, by: 3, range: weather.binRange).thresholds) { _ in
                AxisValueLabel(format: .dateTime.hour())
                AxisTick()
                AxisGridLine()
            }
        }
    }
}

struct HourlyForecastChart_Previews: PreviewProvider {
    static func placeholderHourlyWeather(hourOffset: Int, degrees: Double, isDaylight: Bool) -> HourlyWeather {
        HourlyWeather(
            date: Date().addingTimeInterval(TimeInterval(hourOffset) * 60 * 60),
            temperature: Measurement<UnitTemperature>(value: degrees, unit: .fahrenheit),
            isDaylight: isDaylight
        )
    }

    static var placeholderWeather: LocationWeather {
        return LocationWeather(
            temperature: Measurement(value: 20, unit: .celsius),
            condition: "Cloudy",
            symbolName: "cloud",
            isDaylight: true,
            hourlyForecast: [
                placeholderHourlyWeather(hourOffset: 0, degrees: 63, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 1, degrees: 68, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 2, degrees: 72, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 3, degrees: 77, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 4, degrees: 80, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 5, degrees: 82, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 6, degrees: 83, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 7, degrees: 83, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 8, degrees: 81, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 9, degrees: 79, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 10, degrees: 75, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 11, degrees: 70, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 12, degrees: 66, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 13, degrees: 64, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 14, degrees: 63, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 15, degrees: 61, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 16, degrees: 60, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 17, degrees: 59, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 18, degrees: 57, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 19, degrees: 56, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 20, degrees: 55, isDaylight: false),
                placeholderHourlyWeather(hourOffset: 21, degrees: 55, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 22, degrees: 56, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 23, degrees: 59, isDaylight: true),
                placeholderHourlyWeather(hourOffset: 24, degrees: 62, isDaylight: true)
            ])
    }

    static var previews: some View {
        HourlyForecastChart(weather: placeholderWeather)
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
