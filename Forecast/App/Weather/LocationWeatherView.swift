//
//  LocationWeatherView.swift
//  Forecast
//
//  Created by Rhys Powell on 15/6/2022.
//

import SwiftUI

struct LocationWeatherView: View {
    @EnvironmentObject var model: ForecastModel
    @Environment(\.refresh) private var refresh

    let locationID: Location.ID

    var location: Location! { model.location(for: locationID) }

    var body: some View {
        ScrollView {
            if let weather = model.weather(for: locationID) {
                VStack {
                    CurrentConditionsCard(weather: weather)

                    Card {
                        HStack {
                            Image(systemName: "clock")
                            Text("Hourly Forecast")
                        }
                    } content: {
                        HourlyForecastChart(weather: weather)
                            .aspectRatio(2, contentMode: .fit)
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .toolbar {
            Button {
                Task {
                    await refresh?()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .keyboardShortcut("R")
            .disabled(refresh == nil)

        }
        .navigationTitle(location.name)
        #if os(macOS)
        .frame(minWidth: 400)
        #endif
    }
}

struct CurrentConditionsCard: View {
    let weather: LocationWeather

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: weather.symbolName)
                Text(weather.temperature.formatted(.measurement(
                    width: .narrow,
                    usage: .weather,
                    numberFormatStyle: .number.precision(.fractionLength(0))
                )))
                Spacer()
            }
            .font(Font.system(size: 48, weight: .bold, design: .rounded))

            Text(weather.condition)
        }
        .padding()
        .background(weather.isDaylight ? Gradient.skyDay : Gradient.skyNight, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .colorScheme(.dark)
        .padding(.bottom)
        .frame(maxWidth: 600)
    }
}

struct LocationWeatherView_Previews: PreviewProvider {
    static let model = ForecastModel()

    static var previews: some View {
        NavigationStack {
            LocationWeatherView(locationID: model.locations.first!.id)
                .environmentObject(model)
                .task { await model.updateForecasts() }
        }
    }
}
