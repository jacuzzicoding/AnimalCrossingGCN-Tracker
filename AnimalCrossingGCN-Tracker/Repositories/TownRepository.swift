//
//  TownRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Repository for managing Town entities
class TownRepository: BaseRepository<Town> {
    // MARK: - Repository Protocol Implementation
    
    /// Retrieves all towns from the database
    /// - Returns: Array of all towns
    func getAll() -> [Town] {
        let descriptor = createFetchDescriptor(
            sortBy: [SortDescriptor(\Town.name)]
        )
        return executeFetch(descriptor)
    }
    
    /// Retrieves a town by its name (since Town may not have an ID property yet)
    /// - Parameter name: The name of the town
    /// - Returns: The town if found, nil otherwise
    func getByName(name: String) -> Town? {
        let predicate = #Predicate<Town> { town in
            town.name == name
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor).first
    }
    
    /// Retrieves the current (or default) town
    /// - Returns: The current town if it exists, otherwise nil
    func getCurrentTown() -> Town? {
        let descriptor = createFetchDescriptor()
        let towns = executeFetch(descriptor)
        return towns.first
    }
    
    /// Saves a town to the database
    /// - Parameter item: The town to save
	override func save(_ item: Town) {
        // Since Town doesn't have an ID yet, check by name
        if getByName(name: item.name) == nil {
            modelContext.insert(item)
        }
        
        saveContext()
    }
    
    /// Deletes a town from the database
    /// - Parameter item: The town to delete
	override func delete(_ item: Town) {
        modelContext.delete(item)
        saveContext()
    }
    
    /// Updates the town's name
    /// - Parameters:
    ///   - town: The town to update
    ///   - newName: The new name for the town
    /// - Returns: Whether the update was successful
    @discardableResult
    func updateName(town: Town, newName: String) -> Bool {
        town.name = newName
        return saveContext()
    }
    
    /// Creates a default town if none exists
    /// - Returns: The created default town
    func createDefaultTown() -> Town {
        let defaultTown = Town(name: "My Town")
        modelContext.insert(defaultTown)
        saveContext()
        return defaultTown
    }
    
    /// Ensures a town exists, creating a default one if necessary
    /// - Returns: An existing town or a newly created default town
    func ensureTownExists() -> Town {
        if let town = getCurrentTown() {
            return town
        } else {
            return createDefaultTown()
        }
    }
}
