//
//  Location.swift
//  Forecast
//
//  Created by Rhys Powell on 15/6/2022.
//

import CoreLocation

struct Location: Codable, Hashable, Identifiable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension Location {
    static var sydney: Location {
        Location(
            name: "Sydney",
            latitude: -33.865143,
            longitude: 151.209900
        )
    }
}
