//
//  LocationPoint.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import Foundation

struct LocationPoint {
    let latitude: Double
    let longitude: Double
    let relatedName: String?

    let source: Source?
    let obtainedAt: Date?

    enum Source: Int {
        case geolocalization, manually
    }

    init(latitude: Double, longitude: Double, relatedName: String? = nil, source: LocationPoint.Source? = nil, obtainedAt: Date? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.relatedName = relatedName
        self.source = source
        self.obtainedAt = obtainedAt
    }

    func toTuple() -> (x: Double, y: Double) {
        return (x: longitude, y: latitude)
    }
}

extension LocationPoint {
    static func examplePoints() -> [LocationPoint] {
        let politecnico = LocationPoint(
            latitude: -25.450797458953218,
            longitude: -49.231733212404365,
            relatedName: "Politécnico"
        )

        let jockeyPlaza = LocationPoint(
            latitude: -25.42961165831857,
            longitude: -49.21442003679073,
            relatedName: "Jockey Plaza"
        )

        let estacao = LocationPoint(
            latitude: -25.437978201876945,
            longitude: -49.266369974740044,
            relatedName: "Estação"
        )

        return [politecnico, jockeyPlaza, estacao]
    }
}
