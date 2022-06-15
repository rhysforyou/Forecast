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

    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
        .commands {
            SidebarCommands()
        }
    }
}
