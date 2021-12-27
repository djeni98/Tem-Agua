//
//  RepositoryService.swift
//  Tem Agua
//
//  Created by Djenifer Renata Pereira on 27/12/21.
//

import Foundation

class RepositoryService {
    let api = APIService()

    func getObjectId(x: Double, y: Double, wkid: Int = 4326) async throws -> Int {
        do {
            let (id, _) = try await api.getLocationRelatedInfo(x: x, y: y, wkid: wkid)
            return id
        } catch {
            throw RepositoryError.objectIdError(error as? APIError ?? APIError.unknown)
        }
    }

    func getCurrentWaterRotation(objectId: Int) async throws -> WaterRotation? {
        do {
            let relatedRecords = try await api.getCurrentWaterRotation(objectId: objectId)
            if let record = relatedRecords.first { return WaterRotation.from(record)
            } else { return nil }
        } catch {
            throw RepositoryError.currentRotationError(error as? APIError ?? APIError.unknown)
        }
    }

    func getNewWaterRotationWithin24Hours(objectId: Int) async throws -> WaterRotation? {
        do {
            let relatedRecords = try await api.getNewWaterRotationWithin24Hours(objectId: objectId)
            if let record = relatedRecords.first { return WaterRotation.from(record)
            } else { return nil }
        } catch {
            throw RepositoryError.within24HoursRotationError(error as? APIError ?? APIError.unknown)
        }
    }
}
