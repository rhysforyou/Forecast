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
    var weather: LocationWeather! { model.weather(for: locationID) }

    var body: some View {
        ScrollView {
            VStack {
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

                Card {
                    HStack {
                        Image(systemName: "clock")
                        Text("Hourly Forecast")
                    }
                } content: {
                    HourlyForecastChart(locationID: locationID)
                        .aspectRatio(2, contentMode: .fit)
                }
                .padding()
            }
            .padding()
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
