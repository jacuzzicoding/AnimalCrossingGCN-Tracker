//
//  GlobalSearchService.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/28/25.
//

import Foundation
import SwiftData

/// Service for searching across all collectible categories
class GlobalSearchServiceImpl: GlobalSearchServiceProtocol {
    private let modelContext: ModelContext
    private let fossilRepository: FossilRepository
    private let bugRepository: BugRepository
    private let fishRepository: FishRepository
    private let artRepository: ArtRepository
    
    // Stores recent searches for history feature
    private var searchHistory: [String] = []
    
    /// Initializes the service with required dependencies
    /// - Parameter modelContext: The SwiftData context to use
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fossilRepository = FossilRepository(modelContext: modelContext)
        self.bugRepository = BugRepository(modelContext: modelContext)
        self.fishRepository = FishRepository(modelContext: modelContext)
        self.artRepository = ArtRepository(modelContext: modelContext)
    }
    
    /// Searches across all categories
    /// - Parameters:
    ///   - query: The search text to use
    ///   - townId: Optional town ID to filter results
    /// - Returns: Global search results containing items from all categories
    func searchAllCategories(query: String, townId: UUID? = nil) -> GlobalSearchResults {
        // Normalize the search query
        let normalizedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If query is empty, return empty results
        if normalizedQuery.isEmpty {
            return GlobalSearchResults(
                fossils: [],
                bugs: [],
                fish: [],
                art: []
            )
        }
        
        // Add to search history (if not already present)
        if !searchHistory.contains(normalizedQuery) {
            searchHistory.insert(normalizedQuery, at: 0)
            // Limit history size
            if searchHistory.count > 10 {
                searchHistory.removeLast()
            }
        }
        
        // Get all items based on the townId filter
        var fossils = townId != nil ? 
            fossilRepository.getByTownId(townId: townId!) : 
            fossilRepository.getAll()
        
        var bugs = townId != nil ? 
            bugRepository.getByTownId(townId: townId!) : 
            bugRepository.getAll()
        
        var fish = townId != nil ? 
            fishRepository.getByTownId(townId: townId!) : 
            fishRepository.getAll()
        
        var art = townId != nil ? 
            artRepository.getByTownId(townId: townId!) : 
            artRepository.getAll()
        
        // Filter each category by the search query
        fossils = fossils.filter { 
            $0.name.lowercased().contains(normalizedQuery) || 
            ($0.part?.lowercased().contains(normalizedQuery) ?? false)
        }
        
        bugs = bugs.filter { 
            $0.name.lowercased().contains(normalizedQuery) || 
            ($0.season?.lowercased().contains(normalizedQuery) ?? false)
        }
        
        fish = fish.filter { 
            $0.name.lowercased().contains(normalizedQuery) || 
            $0.season.lowercased().contains(normalizedQuery)
        }
        
        art = art.filter { 
            $0.name.lowercased().contains(normalizedQuery) || 
            $0.basedOn.lowercased().contains(normalizedQuery)
        }
        
        return GlobalSearchResults(
            fossils: fossils,
            bugs: bugs,
            fish: fish,
            art: art
        )
    }
    
    /// Gets the search history
    /// - Returns: Array of recent search strings
    func getSearchHistory() -> [String] {
        return searchHistory
    }
    
    /// Clears the search history
    func clearSearchHistory() {
        searchHistory.removeAll()
    }
}

/// Structure to hold search results from all categories
struct GlobalSearchResults {
    let fossils: [Fossil]
    let bugs: [Bug]
    let fish: [Fish]
    let art: [Art]
    
    /// Total count of results across all categories
    var totalCount: Int {
        return fossils.count + bugs.count + fish.count + art.count
    }
    
    /// Check if there are any results
    var isEmpty: Bool {
        return totalCount == 0
    }
    
    /// Get counts as a dictionary for analytics
    var categoryCounts: [Category: Int] {
        return [
            .fossils: fossils.count,
            .bugs: bugs.count,
            .fish: fish.count,
            .art: art.count
        ]
    }
}
