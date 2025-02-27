//
//  BugRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Repository for managing Bug entities
class BugRepository: BaseRepository<Bug>, CollectibleRepository {
    // MARK: - Repository Protocol Implementation
    
    /// Retrieves all bugs from the database
    /// - Returns: Array of all bugs
    func getAll() -> [Bug] {
        let descriptor = createFetchDescriptor(
            sortBy: [SortDescriptor(\Bug.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves a bug by its ID
    /// - Parameter id: The UUID of the bug
    /// - Returns: The bug if found, nil otherwise
    func getById(id: UUID) -> Bug? {
        let predicate = #Predicate<Bug> { bug in
            bug.id == id
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor).first
    }
    
    /// Saves a bug to the database
    /// - Parameter item: The bug to save
    func save(_ item: Bug) {
        // Check if this is a new item or an existing one
        if getById(id: item.id) == nil {
            modelContext.insert(item)
        }
        
        saveContext()
    }
    
    /// Deletes a bug from the database
    /// - Parameter item: The bug to delete
    func delete(_ item: Bug) {
        modelContext.delete(item)
        saveContext()
    }
    
    // MARK: - CollectibleRepository Protocol Implementation
    
    /// Retrieves bugs based on their donation status
    /// - Parameter donated: The donation status to filter by
    /// - Returns: Array of bugs matching the donation status
    func getByDonationStatus(donated: Bool) -> [Bug] {
        let predicate = #Predicate<Bug> { bug in
            bug.isDonated == donated
        }
        let descriptor = createFetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\Bug.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves bugs available in a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: Array of bugs available in the specified game
    func getByGame(_ game: ACGame) -> [Bug] {
        let descriptor = FetchDescriptor<Bug>()
        let bugs = executeFetch(descriptor)
        
        // Filter the bugs based on game availability
        return bugs.filter { bug in
            bug.games.contains(game)
        }
    }
    
    // MARK: - Bug-Specific Methods
    
    /// Retrieves bugs available in a specific season
    /// - Parameter season: The season to search for
    /// - Returns: Array of bugs available in the specified season
    func getBySeason(_ season: String) -> [Bug] {
        let predicate = #Predicate<Bug> { bug in
            bug.season == season
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
}
