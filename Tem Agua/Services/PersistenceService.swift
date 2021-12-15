//
//  PersistenceService.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 10/10/21.
//

import Foundation

class PersistenceService {
    let defaults = UserDefaults.standard

    func getLocationPoint() -> LocationPoint? {
        guard defaults.bool(forKey: "savedLocation") else { return nil }

        let latitude = defaults.double(forKey: "latitude")
        let longitude = defaults.double(forKey: "longitude")
        let relatedName = defaults.string(forKey: "relatedName")
        let addressString = defaults.string(forKey: "addressString")
        let source = defaults.integer(forKey: "source")
        let obtainedAt = defaults.object(forKey: "obtainedAt") as? Date

        return LocationPoint(
            latitude: latitude,
            longitude: longitude,
            relatedName: relatedName,
            addressString: addressString,
            source: LocationPoint.Source(rawValue: source),
            obtainedAt: obtainedAt
        )
    }

    func saveLocationPoint(_ locationPoint: LocationPoint) {
        defaults.set(true, forKey: "savedLocation")
        defaults.set(locationPoint.latitude, forKey: "latitude")
        defaults.set(locationPoint.longitude, forKey: "longitude")
        defaults.set(locationPoint.relatedName, forKey: "relatedName")
        defaults.set(locationPoint.addressString, forKey: "addressString")
        defaults.set(locationPoint.source?.rawValue ?? -1, forKey: "source")
        defaults.set(locationPoint.obtainedAt, forKey: "obtainedAt")
    }

    func removeLocationPoint() {
        for key in ["savedLocation", "latitude", "longitude", "relatedName", "addressString", "source", "obtainedAt"] {
            defaults.removeObject(forKey: key)
        }
    }

    func getLastSearchDate() -> Date? {
        return defaults.object(forKey: "lastSearchDate") as? Date
    }

    func saveLastSearchDate(_ date: Date) {
        defaults.set(date, forKey: "lastSearchDate")
    }
}
