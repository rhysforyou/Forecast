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
    @EnvironmentObject var model: ForecastModel

    let locationID: Location.ID

    var body: some View {
        if let weather = model.weather(for: locationID) {
            Chart(weather.hourlyForecast, id: \.date) { hour in
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
}

struct HourlyForecastChart_Previews: PreviewProvider {
    struct Preview: View {
        @ObservedObject var model = ForecastModel()

        var body: some View {
            HourlyForecastChart(locationID: model.locations.first!.id)
            .environmentObject(model)
            .task { await model.updateForecasts() }
        }
    }

    static var previews: some View {
        Preview()
            .aspectRatio(2, contentMode: .fit)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
