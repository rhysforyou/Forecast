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
    static var previews: some View {
        HourlyForecastChart(weather: .placeholderWeather)
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
