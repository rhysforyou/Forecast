//
//  Gradients.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

extension Gradient {
    static var skyDay: Gradient {
        Gradient(colors: [
            Color("Sky Gradient/Day Top"),
            Color("Sky Gradient/Day Bottom")
        ])
    }

    static var skyNight: Gradient {
        Gradient(colors: [
            Color("Sky Gradient/Night Top"),
            Color("Sky Gradient/Night Bottom")
        ])
    }
}
