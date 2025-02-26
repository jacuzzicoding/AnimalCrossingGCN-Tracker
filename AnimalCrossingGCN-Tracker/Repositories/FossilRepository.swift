//
//  FossilRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Repository for managing Fossil entities
class FossilRepository: BaseRepository<Fossil>, CollectibleRepository {
    // MARK: - Repository Protocol Implementation
    
    /// Retrieves all fossils from the database
    /// - Returns: Array of all fossils
    func getAll() -> [Fossil] {
        let descriptor = createFetchDescriptor(
            sortBy: [SortDescriptor(\Fossil.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves a fossil by its ID
    /// - Parameter id: The UUID of the fossil
    /// - Returns: The fossil if found, nil otherwise
    func getById(id: UUID) -> Fossil? {
        let predicate = #Predicate<Fossil> { fossil in
            fossil.id == id
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor).first
    }
    
    /// Saves a fossil to the database
    /// - Parameter item: The fossil to save
    func save(_ item: Fossil) {
        // Check if this is a new item or an existing one
        if getById(id: item.id) == nil {
            modelContext.insert(item)
        }
        
        saveContext()
    }
    
    /// Deletes a fossil from the database
    /// - Parameter item: The fossil to delete
    func delete(_ item: Fossil) {
        modelContext.delete(item)
        saveContext()
    }
    
    // MARK: - CollectibleRepository Protocol Implementation
    
    /// Retrieves fossils based on their donation status
    /// - Parameter donated: The donation status to filter by
    /// - Returns: Array of fossils matching the donation status
    func getByDonationStatus(donated: Bool) -> [Fossil] {
        let predicate = #Predicate<Fossil> { fossil in
            fossil.isDonated == donated
        }
        let descriptor = createFetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\Fossil.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves fossils available in a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: Array of fossils available in the specified game
    func getByGame(_ game: ACGame) -> [Fossil] {
        let descriptor = FetchDescriptor<Fossil>()
        let fossils = executeFetch(descriptor)
        
        // Filter the fossils based on game availability
        return fossils.filter { fossil in
            fossil.games.contains(game)
        }
    }
    
    // MARK: - Fossil-Specific Methods
    
    /// Retrieves fossils that are part of a specific dinosaur or set
    /// - Parameter part: The dinosaur part to search for
    /// - Returns: Array of fossils matching the part
    func getByPart(_ part: String) -> [Fossil] {
        let predicate = #Predicate<Fossil> { fossil in
            fossil.part == part
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
}
