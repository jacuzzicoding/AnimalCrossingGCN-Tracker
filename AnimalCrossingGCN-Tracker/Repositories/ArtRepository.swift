//
//  ArtRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Repository for managing Art entities
class ArtRepository: BaseRepository<Art>, CollectibleRepository {
    // MARK: - Repository Protocol Implementation
    
    /// Retrieves all art pieces from the database
    /// - Returns: Array of all art pieces
    func getAll() -> [Art] {
        let descriptor = createFetchDescriptor(
            sortBy: [SortDescriptor(\Art.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves an art piece by its ID
    /// - Parameter id: The UUID of the art piece
    /// - Returns: The art piece if found, nil otherwise
    func getById(id: UUID) -> Art? {
        let predicate = #Predicate<Art> { art in
            art.id == id
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor).first
    }
    
    /// Saves an art piece to the database
    /// - Parameter item: The art piece to save
	override func save(_ item: Art) {
        // Check if this is a new item or an existing one
        if getById(id: item.id) == nil {
            modelContext.insert(item)
        }
        
        saveContext()
    }
    
    /// Deletes an art piece from the database
    /// - Parameter item: The art piece to delete
    func delete(_ item: Art) {
        modelContext.delete(item)
        saveContext()
    }
    
    // MARK: - CollectibleRepository Protocol Implementation
    
    /// Retrieves art pieces based on their donation status
    /// - Parameter donated: The donation status to filter by
    /// - Returns: Array of art pieces matching the donation status
    func getByDonationStatus(donated: Bool) -> [Art] {
        let predicate = #Predicate<Art> { art in
            art.isDonated == donated
        }
        let descriptor = createFetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\Art.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves art pieces available in a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: Array of art pieces available in the specified game
    func getByGame(_ game: ACGame) -> [Art] {
        let descriptor = FetchDescriptor<Art>()
        let artPieces = executeFetch(descriptor)
        
        // Filter the art pieces based on game availability
        return artPieces.filter { art in
            art.games.contains(game)
        }
    }
    
    // MARK: - Art-Specific Methods
    
    /// Retrieves art pieces based on their real-world reference
    /// - Parameter reference: The real-world artwork reference to search for
    /// - Returns: Array of art pieces matching the reference
    func getByBasedOn(_ reference: String) -> [Art] {
        let predicate = #Predicate<Art> { art in
            art.basedOn == reference
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
    
    // getByTownId method is now provided by BaseRepository<T> where T: TownLinkable extension
}
