//  RepositoryError.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/18/25.
//

import Foundation

/// Domain-specific errors for repository operations
public enum RepositoryError: Error {
    /// Thrown when saving an entity fails
    case saveFailed(entityName: String, underlyingError: Error)
    // Future error cases (e.g., deleteFailed, fetchFailed) can be added here
}
