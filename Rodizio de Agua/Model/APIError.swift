//
//  APIError.swift
//  Rodizio de Agua
//
//  Created by Djenifer Renata Pereira on 12/10/21.
//

enum APIError: Error {
    case serverError(Error)
    case dataNotAvailable
    case jsonSerializationError
    case dictionaryConversionError
    case apiError([String: Any])

    case dataExtractionFailure(ExtractionFailure)

    enum ExtractionFailure {
        case feature
        case objectId
        case relatedGroups
    }
}
