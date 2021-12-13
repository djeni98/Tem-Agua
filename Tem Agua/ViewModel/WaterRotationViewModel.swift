//
//  WaterRotationViewModel.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 08/10/21.
//

struct WaterRotationViewModel {
    let model: WaterRotation

    func getInfoTextAboutCurrentRotation() -> String {
        let startDayText = model.inicio.toRelativePortugueseText()
        let endDayText = model.normalizacao.toRelativePortugueseText()

        var text = "A água acabou \(startDayText) e a previsão de volta é \(endDayText)"
        if let periodo = model.periodo, !periodo.isEmpty {
            text += " (\(periodo))"
        }

        return text
    }

    func getInfoTextAbout24HoursRotation() -> String {
        let startDayText = model.inicio.toRelativePortugueseText()
        let endDayText = model.normalizacao.toRelativePortugueseText()

        var text = "Mas tem um rodízio nas próximas 24 horas.\n"
        text += "Começa \(startDayText) e a previsão de volta é \(endDayText)"
        if let periodo = model.periodo, !periodo.isEmpty {
            text += " (\(periodo))"
        }

        return text
    }
}
