//
//  ContentView.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.refresh) private var refresh

    @ObservedObject var weatherRepository: WeatherRepository

    var body: some View {
        ScrollView {
            VStack {
                if let currentWeather = weatherRepository.currentWeather, let forecast = weatherRepository.hourlyForecast {
                    HStack {
                        Image(systemName: currentWeather.symbolName)
                        Text(currentWeather.temperature.formatted(.measurement(
                            width: .narrow,
                            usage: .weather,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                        )))
                    }
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 48, weight: .medium, design: .rounded))

                    Text(currentWeather.condition.description)
                        .foregroundColor(.secondary)
                        .padding(.bottom)

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
                    await refresh?()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }.disabled(refresh == nil)
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #elseif os(macOS)
        .frame(minWidth: 400)
        #endif
        .task { await weatherRepository.fetchWeather() }
        .refreshable { await weatherRepository.fetchWeather() }
    }
}

struct Card<Title, Content>: View where Title: View, Content: View {
    let title: Title
    let content: Content

    init(@ViewBuilder title: () -> Title, @ViewBuilder content: () -> Content) {
        self.title = title()
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            title
                .foregroundColor(.secondary)
                .padding(.bottom)

            content
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        #elseif os(macOS)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(style: StrokeStyle())
                    .opacity(0.1)

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray.opacity(0.1))
            }
        }
        #endif
        .padding(.bottom, 8)
        .frame(maxWidth: 600)
    }
}

extension Card where Title == Text {
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = Text(title)
        self.content = content()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(weatherRepository: WeatherRepository())
        }
    }
}
