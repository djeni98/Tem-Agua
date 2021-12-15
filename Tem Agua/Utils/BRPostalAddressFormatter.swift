//
//  BRPostalAddressFormatter.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 15/12/21.
//

import Contacts

class BRPostalAddressFormatter {
    func string(from postalAddress: CNPostalAddress) -> String {
        let street = postalAddress.street
        let subLocality = postalAddress.subLocality
        let city = postalAddress.city
        let state = postalAddress.state
        let postalCode = postalAddress.postalCode

        return "\(street) - \(subLocality), \(city) - \(state), \(postalCode)"
    }
}
