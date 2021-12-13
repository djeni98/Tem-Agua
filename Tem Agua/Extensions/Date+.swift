//
//  Date+.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 08/10/21.
//

import Foundation

extension Date {
    func toRelativePortugueseText(with timeZone: TimeZone = TimeZone.current) -> String {
        var relativeDay: String?

        if Calendar.current.isDateInYesterday(self) {
            relativeDay = "ontem"
        } else if Calendar.current.isDateInToday(self) {
            relativeDay = "hoje"
        } else if Calendar.current.isDateInTomorrow(self) {
            relativeDay = "amanhã"
        }

        guard let relativeDay = relativeDay else {
            return "dia \(self.toPortugueseText())"
        }

        return "\(relativeDay) às \(self.getHoursInPortugueseText())"
    }

    func getHoursInPortugueseText(with timeZone: TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH"

        let string = formatter.string(from: self)
        return "\(string) hora" + (string != "01" ? "s" : "")
    }

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
