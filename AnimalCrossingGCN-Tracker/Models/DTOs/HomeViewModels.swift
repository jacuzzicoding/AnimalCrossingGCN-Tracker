//
//  HomeViewModels.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/6/25.
//

import Foundation
import SwiftUI

/// Data models for the Home screen view model

/// Represents overall collection status
struct CollectionStatusData {
    let totalCollected: Int
    let totalAvailable: Int
    let completionPercentage: Double
    
    static var empty: CollectionStatusData {
        return CollectionStatusData(totalCollected: 0, totalAvailable: 0, completionPercentage: 0.0)
    }
}

/// Represents progress for a single category
struct CategoryProgressData: Identifiable {
    let id = UUID()
    let category: Category
    let name: String
    let icon: String
    let color: Color
    let collected: Int
    let total: Int
    let progress: Double
    
    var progressPercentage: Int {
        Int(progress * 100)
    }
    
    static var empty: [CategoryProgressData] {
        return []
    }
}

/// Enum for data manager specific errors
enum DataManagerError: Error, LocalizedError {
    case noCurrentTown
    case dataNotAvailable
    case loadingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noCurrentTown:
            return "No town selected. Please create or select a town."
        case .dataNotAvailable:
            return "The requested data is not available."
        case .loadingFailed(let reason):
            return "Failed to load data: \(reason)"
        }
    }
}

/// Protocol for data manager functionality required by HomeViewModel
protocol DataManaging {
    func fetchCollectionStatus() async throws -> CollectionStatusData
    func fetchCategoryProgress() async throws -> [CategoryProgressData]
    func fetchSeasonalHighlights() async throws -> [SeasonalItem]
    func fetchRecentDonations() async throws -> [DonationItem]
}
