//
//  APIService.swift
//  Tem Agua
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

        let charset = CharacterSet(charactersIn: "/+/(/)/</>").inverted
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: charset)

        return urlComponents.url
    }

    private func request(with url: URL) async throws -> [String: Any] {
        typealias RequestContinuation = CheckedContinuation<[String: Any], Error>
        return try await withCheckedThrowingContinuation { (continuation: RequestContinuation) in
            request(with: url) { dictionary, error in
                if let dictionary = dictionary {
                    continuation.resume(returning: dictionary)
                } else {
                    continuation.resume(throwing: error ?? APIError.asyncError)
                }
            }
        }
    }

    private func request(with url: URL, completion: @escaping ([String: Any]?, APIError?) -> Void) {
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(#line): Server Error")

                completion(nil, .serverError(error))
                return
            }

            guard let data = data else {
                print("\(#line): Data not available")

                completion(nil, .dataNotAvailable)
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("\(#line): Could not get json from data")
                print(data)

                completion(nil, .jsonSerializationError)
                return
            }

            guard let dictionary = json as? [String: Any] else {
                print("\(#line): Could not transform json to dictionary.")
                print(json)

                completion(nil, .dictionaryConversionError)
                return
            }

            if dictionary.keys.contains("error") {
                print("\(#line): API Error")
                print(dictionary["error"]!)

                completion(nil, .apiError(dictionary))
                return
            }

            completion(dictionary, nil)
        }

        request.resume()
    }

    func getLocationRelatedInfo(x: Double, y: Double, wkid: Int = 4326, completion: @escaping (Int?, [[[Double]]]?, APIError?) -> Void) {
        let parameters = getParametersForLocationRequest(x: x, y: y, wkid: wkid)
        guard let url = getURL(from: parameters) else { return }

        request(with: url) { dictionary, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }

            guard let dictionary = dictionary else { return }

            guard let features = dictionary["features"] as? [[String: Any]],
                  let feature = features.first
            else {
                print("\(#line): Could not extract feature from dictionary.")
                print(dictionary)

                completion(nil, nil, .dataExtractionFailure(.feature))
                return
            }

            guard let id = feature["id"] as? Int,
                  let geometry = feature["geometry"] as? [String: Any],
                  let coordinates = geometry["coordinates"] as? [[[Double]]]
            else {
                print("\(#line): Could not extract id and polygon coordinates from feature.")

                completion(nil, nil, .dataExtractionFailure(.objectId))
                return
            }

            completion(id, coordinates, nil)
        }
    }

    func getCurrentWaterRotation(objectId: Int) async throws -> [[String: Any]] {
        let sqlParam = "(CURRENT_TIMESTAMP BETWEEN INICIO AND NORMALIZACAO)"
        return try await requestRelationship(sqlParam: sqlParam, objectId: objectId)
    }

    func getNewWaterRotationWithin24Hours(objectId: Int) async throws -> [[String: Any]] {
        let sqlParam = "(INICIO BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + 1)"
        return try await requestRelationship(sqlParam: sqlParam, objectId: objectId)
    }

    func getNextWaterRotation(objectId: Int) async throws -> [[String: Any]] {
        let sqlParam = "(INICIO > CURRENT_TIMESTAMP)"
        return try await requestRelationship(sqlParam: sqlParam, objectId: objectId)
    }

    private func requestRelationship(sqlParam: String, objectId: Int) async throws -> [[String: Any]] {
        var parameters = getParametersForRelationshipRequest(objectId: "\(objectId)", from: .poligonoRodizio, to: .tabelaRodizio)

        parameters.queryItems.append(
            URLQueryItem(name: "definitionExpression", value: sqlParam)
        )

        guard let url = getURL(from: parameters) else { throw APIError.URLError }
        let dictionary = try await request(with: url)

        guard let relatedRecords = self.getRelatedRecords(from: dictionary) else {
            print("\(#line): Could not extract related records from dictionary.")
            throw APIError.dataExtractionFailure(.relatedGroups)
        }

        return relatedRecords
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

    private func getParametersForLocationRequest(x: Double, y: Double, wkid: Int = 4326) -> Parameters {
        var params = [
            "f": "geojson",
            "returnGeometry": "true",
            "spatialRel": "esriSpatialRelIntersects",
            "geometryType": "esriGeometryPoint",
            "inSR": "\(wkid)",
            "outFields": "*",
            "outSR": "\(wkid)",
        ]

        let spatialReference = #"{"wkid":\#(wkid)}"#
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
