//
//  ContentView.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherRepository: WeatherRepository

    var body: some View {
        ScrollView {
            VStack {
                if let currentWeather = weatherRepository.currentWeather, let forecast = weatherRepository.hourlyForecast {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: currentWeather.symbolName)
                            Text(currentWeather.temperature.formatted(.measurement(
                                width: .narrow,
                                usage: .weather,
                                numberFormatStyle: .number.precision(.fractionLength(0))
                            )))
                            Spacer()
                        }
                        .symbolRenderingMode(.multicolor)
                        .font(Font.system(size: 48, weight: .bold, design: .rounded))

                        Text(currentWeather.condition.description)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(currentWeather.isDaylight ? Gradient.skyDay : Gradient.skyNight, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .colorScheme(.dark)
                    .padding(.bottom)
                    .frame(maxWidth: 600)

                    Card {
                        HStack {
                            Image(systemName: "clock")
                            Text("Hourly Forecast")
                        }
                    } content: {
                        HourlyForecastChart(forecast: .init(forecast: forecast))
                            .aspectRatio(2, contentMode: .fit)
                    }
                } else {
                    HStack {
                        Spacer()
                            .controlSize(.large)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Forecast")
        .toolbar {
            Button {
                Task {
                    await weatherRepository.fetchWeather()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #elseif os(macOS)
        .frame(minWidth: 400)
        #endif
        .task { await weatherRepository.fetchWeather() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(weatherRepository: WeatherRepository())
        }
    }
}
