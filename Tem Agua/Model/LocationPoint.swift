//
//  LocationPoint.swift
//  Tem Agua
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

    func getObservationText() -> String? {
        guard let source = source, let obtainedAt = obtainedAt else { return nil }

        switch source {
        case .geolocalization:
            return "Obtido por geolocalização em \(obtainedAt.toPortugueseText())"
        case .manually:
            return "Informado manualmente em \(obtainedAt.toPortugueseText())"
        }
    }
}

extension LocationPoint {
    static func examplePoints() -> [LocationPoint] {
        let group1 = LocationPoint(
            latitude: -25.42961165831857,
            longitude: -49.21442003679073,
            relatedName: "Jockey Plaza",
            source: .manually
        )

        let group2 = LocationPoint(
            latitude: -25.450797458953218,
            longitude: -49.231733212404365,
            relatedName: "Politécnico",
            source: .manually
        )

        let group3 = LocationPoint(
            latitude: -25.437978201876945,
            longitude: -49.266369974740044,
            relatedName: "Estação",
            source: .manually
        )

        return [group1, group2, group3]
    }
}
