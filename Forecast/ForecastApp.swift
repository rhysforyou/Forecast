//
//  ForecastApp.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

@main
struct ForecastApp: App {
    @StateObject private var model = ForecastModel()
    @Environment(\.refresh) var refresh

    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
        .commands {
            SidebarCommands()
            CommandMenu("Locations") {
                Button("Refresh") {
                    Task { await refresh?() }
                }
                .disabled(refresh == nil)
                .keyboardShortcut("R")
            }
        }
    }
}
