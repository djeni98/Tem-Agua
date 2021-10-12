//
//  WaterRotation.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 08/10/21.
//

import Foundation

struct WaterRotation {
    let retomada: Date
    let normalizacao: Date
    let inicio: Date

    var objectId: Int? = nil
    var localidade: Int? = nil
    var periodo: String? = nil
    var observacao: String? = nil
    var codope: String? = nil

    static func from(_ dictionary: [String: Any]) -> WaterRotation? {
        guard let retomada = dictionary["RETOMADA"] as? Int,
              let normalizacao = dictionary["NORMALIZACAO"] as? Int,
              let inicio = dictionary["INICIO"] as? Int
        else { return nil }

        var waterRotation = WaterRotation(
            retomada: Date.from(miliseconds: retomada),
            normalizacao: Date.from(miliseconds: normalizacao),
            inicio: Date.from(miliseconds: inicio)
        )

        waterRotation.objectId = dictionary["OBJECTID"] as? Int
        waterRotation.localidade = dictionary["LOCALIDADE"] as? Int
        waterRotation.periodo = dictionary["PERIODO"] as? String
        waterRotation.observacao = dictionary["OBSERVACAO"] as? String
        waterRotation.codope = dictionary["CODOPE"] as? String

        return waterRotation
    }
}
