//
//  RepositoryError.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 27/12/21.
//

import Foundation

enum RepositoryError: Error {
    case objectIdError(APIError)
    case currentRotationError(APIError)
    case within24HoursRotationError(APIError)
}
