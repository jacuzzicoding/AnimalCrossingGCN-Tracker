//
//  RepositoryProtocols.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Base repository protocol defining essential CRUD operations
protocol Repository {
    /// The type of model this repository manages
    associatedtype ModelType
    
    /// Retrieves all items of the managed type
    func getAll() -> [ModelType]
    
    /// Retrieves a specific item by its ID
    /// - Parameter id: The unique identifier of the item
    /// - Returns: The item if found, nil otherwise
    func getById(id: UUID) -> ModelType?
    
    /// Saves an item to the repository
    /// - Parameter item: The item to save
    /// - Throws: RepositoryError if the save operation fails
    func save(_ item: ModelType) throws
    
    /// Deletes an item from the repository
    /// - Parameter item: The item to delete
    /// - Throws: RepositoryError if the delete operation fails
    func delete(_ item: ModelType) throws
}

/// Repository protocol for collectible items with additional query capabilities
protocol CollectibleRepository: Repository where ModelType: CollectibleItem {
    /// Retrieves items based on their donation status
    /// - Parameter donated: The donation status to filter by
    /// - Returns: An array of items matching the donation status
    func getByDonationStatus(donated: Bool) -> [ModelType]
    
    /// Retrieves items available in a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: An array of items available in the specified game
    func getByGame(_ game: ACGame) -> [ModelType]
}
