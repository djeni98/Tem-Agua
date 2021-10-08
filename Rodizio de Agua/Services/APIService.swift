//
//  APIService.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 07/10/21.
//

import Foundation

enum Layer: Int {
    case pontoRodizio, poligonoRodizio, tabelaRodizio

    func relationshipIdTo(layer: Layer) -> Int {
        switch self {
        case .pontoRodizio:
            if layer == .poligonoRodizio { return 0 }
            else { return -1 }
        case .poligonoRodizio:
            if layer == .pontoRodizio { return 0 }
            else if layer == .tabelaRodizio { return 1 }
            else { return -1 }
        case .tabelaRodizio:
            if layer == .poligonoRodizio { return 1 }
            else { return -1 }
        }
    }
}

enum Operation: String {
    case query, queryRelatedRecords
}

struct Parameters {
    let layer: Layer
    let operation: Operation
    var queryItems: [URLQueryItem]
}

class APIService {
    private let scheme = "https"
    private let host = "services1.arcgis.com"
    private let path = "/46Oage49MS2a3O6A/arcgis/rest/services/Mapa_Rodizio_Abastecimento_RMC_View/FeatureServer"

    private func getURL(from parameters: Parameters) -> URL? {
        let layerNumber = parameters.layer.rawValue
        let operation = parameters.operation.rawValue

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(path)/\(layerNumber)/\(operation)"
        urlComponents.queryItems = parameters.queryItems

        return urlComponents.url
    }

    private func request(with url: URL, completion: @escaping ([String: Any]) -> Void) {
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                print("\(#line): Server Error")
                return
            }

            guard let data = data else {
                print("\(#line): Data not available")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])

            guard let dictionary = json as? [String: Any] else {
                print("\(#line): Could not transform json to dictionary.")
                return
            }

            if dictionary.keys.contains("error") {
                print("\(#line): API Error")
                print(dictionary["error"]!)
                return
            }

            completion(dictionary)
        }

        request.resume()
    }

    func getLocationRelatedInfo(x: Double, y: Double, completion: @escaping (Int, [[[Double]]]) -> Void) {
        let parameters = getParametersForLocationRequest(x: x, y: y)
        guard let url = getURL(from: parameters) else { return }

        request(with: url) { dictionary in
            guard let features = dictionary["features"] as? [[String: Any]],
                  let feature = features.first
            else {
                print("\(#line): Could not extract feature from dictionary.")
                return
            }

            guard let id = feature["id"] as? Int,
                  let geometry = feature["geometry"] as? [String: Any],
                  let coordinates = geometry["coordinates"] as? [[[Double]]]
            else {
                print("\(#line): Could not extract id and polygon coordinates from feature.")
                return
            }

            completion(id, coordinates)
        }
    }

    func getCurrentWaterRotation(objectId: Int, completion: @escaping ([[String: Any]]) -> Void) {
        var parameters = getParametersForRelationshipRequest(objectId: "\(objectId)", from: .poligonoRodizio, to: .tabelaRodizio)
        let sqlParam = "(CURRENT_TIMESTAMP BETWEEN INICIO AND NORMALIZACAO)"
        parameters.queryItems.append(
            URLQueryItem(name: "definitionExpression", value: sqlParam)
        )

        guard let url = getURL(from: parameters) else { return }

        request(with: url) { dictionary in
            guard let relatedRecords = self.getRelatedRecords(from: dictionary) else {
                print("\(#line): Could not extract related records from dictionary.")
                return
            }

            completion(relatedRecords)
        }
    }

    private func getRelatedRecords(from dictionary: [String: Any]) -> [[String: Any]]? {
        guard let relatedGroups = dictionary["relatedRecordGroups"] as? [[String: Any]] else {
            print("\(#line): Could not extract relatedRecordGroups from dictionary")
            return nil
        }

        var relatedRecords = [[String: Any]]()

        for item in relatedGroups {
            guard let relatedRecordsWithAttr = item["relatedRecords"] as? [[String: Any]] else {
                print("\(#line): Could not extract related records array, continue...")
                continue
            }


            for item in relatedRecordsWithAttr {
                guard let relatedRecord = item["attributes"] as? [String: Any] else {
                    print("\(#line): Could not extract attributes from related record, continue...")
                    continue
                }

                relatedRecords.append(relatedRecord)
            }
        }

        return relatedRecords
    }

    private func getParametersForLocationRequest(x: Double, y: Double) -> Parameters {
        var params = [
            "f": "geojson",
            "returnGeometry": "true",
            "spatialRel": "esriSpatialRelIntersects",
            "geometryType": "esriGeometryPoint",
            "inSR": "102100",
            "outFields": "*",
            "outSR": "102100",
        ]

        let spatialReference = #"{"wkid":102100}"#
        params["geometry"] = #"{"x":\#(x),"y":\#(y),"spatialReference":\#(spatialReference)}"#

        var queryItems = [URLQueryItem]()
        for (name, value) in params {
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        return Parameters(layer: .poligonoRodizio, operation: .query, queryItems: queryItems)
    }

    private func getParametersForRelationshipRequest(objectId: String, from originLayer: Layer, to targetLayer: Layer) -> Parameters {
        var params = [
            "f": "json",
            "returnGeometry": "true",
            "outFields": "*",
        ]

        params["objectIds"] = objectId
        let relationshipId = originLayer.relationshipIdTo(layer: targetLayer)
        params["relationshipId"] = "\(relationshipId)"

        var queryItems = [URLQueryItem]()
        for (name, value) in params {
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        return Parameters(layer: originLayer, operation: .queryRelatedRecords, queryItems: queryItems)
    }
}
