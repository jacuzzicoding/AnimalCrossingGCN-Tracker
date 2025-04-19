//
//  FishRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Repository for managing Fish entities
class FishRepository: BaseRepository<Fish>, CollectibleRepository {
    // MARK: - Repository Protocol Implementation
    
    /// Retrieves all fish from the database
    /// - Returns: Array of all fish
    func getAll() -> [Fish] {
        let descriptor = createFetchDescriptor(
            sortBy: [SortDescriptor(\Fish.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves a fish by its ID
    /// - Parameter id: The UUID of the fish
    /// - Returns: The fish if found, nil otherwise
    func getById(id: UUID) -> Fish? {
        let predicate = #Predicate<Fish> { fish in
            fish.id == id
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor).first
    }
    
    /// Saves a fish to the database
    /// - Parameter item: The fish to save
	override func save(_ item: Fish) {
        // Check if this is a new item or an existing one
        if getById(id: item.id) == nil {
            modelContext.insert(item)
        }
        
        saveContext()
    }
    
    /// Deletes a fish from the database
    /// - Parameter item: The fish to delete
	override func delete(_ item: Fish) {
        modelContext.delete(item)
        saveContext()
    }
    
    // MARK: - CollectibleRepository Protocol Implementation
    
    /// Retrieves fish based on their donation status
    /// - Parameter donated: The donation status to filter by
    /// - Returns: Array of fish matching the donation status
    func getByDonationStatus(donated: Bool) -> [Fish] {
        let predicate = #Predicate<Fish> { fish in
            fish.isDonated == donated
        }
        let descriptor = createFetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\Fish.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves fish available in a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: Array of fish available in the specified game
    func getByGame(_ game: ACGame) -> [Fish] {
        let descriptor = FetchDescriptor<Fish>()
        let fishes = executeFetch(descriptor)
        
        // Filter the fish based on game availability
        return fishes.filter { fish in
            fish.games.contains(game)
        }
    }
    
    // MARK: - Fish-Specific Methods
    
    /// Retrieves fish by location
    /// - Parameter location: The location to search for
    /// - Returns: Array of fish available in the specified location
    func getByLocation(_ location: String) -> [Fish] {
        let predicate = #Predicate<Fish> { fish in
            fish.location == location
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
    
    /// Retrieves fish by season
    /// - Parameter season: The season to search for
    /// - Returns: Array of fish available in the specified season
    func getBySeason(_ season: String) -> [Fish] {
        let predicate = #Predicate<Fish> { fish in
            fish.season == season
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
    
    // getByTownId method is now provided by BaseRepository<T> where T: TownLinkable extension
}
