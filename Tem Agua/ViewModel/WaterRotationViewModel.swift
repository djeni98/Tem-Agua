//
//  WaterRotationViewModel.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 08/10/21.
//

struct WaterRotationViewModel {
    let model: WaterRotation

    func getInfoTextAboutCurrentRotation() -> String {
        let startDayText = model.inicio.toPortugueseText()
        let endDayText = model.normalizacao.toPortugueseText()

        var text = "A água acabou dia \(startDayText) e a previsão de volta é dia \(endDayText)"
        if let periodo = model.periodo, !periodo.isEmpty {
            text += " (\(periodo))"
        }

        return text
    }

    func getInfoTextAbout24HoursRotation() -> String {
        let startDayText = model.inicio.toPortugueseText()
        let endDayText = model.normalizacao.toPortugueseText()

        var text = "Mas tem um rodízio nas próximas 24 horas.\n"
        text += "Começa dia \(startDayText) e a previsão de volta é dia \(endDayText)"
        if let periodo = model.periodo, !periodo.isEmpty {
            text += " (\(periodo))"
        }

        return text
    }
}
