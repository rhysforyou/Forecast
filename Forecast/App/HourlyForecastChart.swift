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
    let forecast: HourlyForecast

    var body: some View {
        Chart(forecast.hourlyWeather, id: \.date) { hour in
            AreaMark(
                x: .value("Date", hour.date),
                y: .value("Temperature", hour.temperature.value)
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
        .chartYAxis {
            AxisMarks(values: .automatic(minimumStride: 5, desiredCount: 6, roundLowerBound: false)) { value in
                AxisValueLabel("\(value.as(Double.self)!.formatted())\(forecast.temperatureUnit.symbol)")
                AxisTick()
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(values: DateBins(unit: .hour, by: 3, range: forecast.binRange).thresholds) { _ in
                AxisValueLabel(format: .dateTime.hour())
                AxisTick()
                AxisGridLine()
            }
        }
    }
}

struct HourlyForecastChart_Previews: PreviewProvider {
    struct Preview: View {
        @ObservedObject var weatherRepository = WeatherRepository()

        var body: some View {
            Group {
                if let forecast = weatherRepository.hourlyForecast {
                    HourlyForecastChart(forecast: .init(forecast: forecast))
                } else {
                    ProgressView()
                }
            }
            .task { await weatherRepository.fetchWeather() }
        }
    }

    static var previews: some View {
        Preview()
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
