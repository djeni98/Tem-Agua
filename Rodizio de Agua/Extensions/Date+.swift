//
//  Date+.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 08/10/21.
//

import Foundation

extension Date {
    func toPortugueseText(with timeZone: TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "dd/MM/yyyy HH:mm"

        let string = formatter.string(from: self)
        return string.split(separator: " ").joined(separator: " às ")
    }

    static func from(miliseconds: Int) -> Date {
        let timeInterval = TimeInterval(miliseconds / 1000)
        return Date(timeIntervalSince1970: timeInterval)
    }
}
