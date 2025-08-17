//
//  GlobalSearchServiceProtocol.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by GitHub Copilot on 5/23/25.
//

import Foundation

/// Protocol defining the interface for global search services
protocol GlobalSearchServiceProtocol {
    /// Searches across all categories for items matching the query
    /// - Parameters:
    ///   - query: The search text to use
    ///   - townId: Optional town ID to filter results
    /// - Returns: Global search results containing items from all categories
    func searchAllCategories(query: String, townId: UUID?) -> GlobalSearchResults
    
    /// Gets the search history
    /// - Returns: Array of recent search strings
    func getSearchHistory() -> [String]
    
    /// Clears the search history
    func clearSearchHistory()
}