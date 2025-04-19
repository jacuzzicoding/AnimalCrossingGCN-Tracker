//
//  BaseRepository.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/25/25.
//

import Foundation
import SwiftData

/// Base class implementing common repository functionality using SwiftData
class BaseRepository<T: PersistentModel> {
    /// The SwiftData context used for database operations
    let modelContext: ModelContext
    
    /// Initializes a new repository with the provided model context
    /// - Parameter modelContext: The SwiftData context to use for database operations
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Creates a fetch descriptor with optional predicate and sort descriptors
    /// - Parameters:
    ///   - predicate: Optional predicate for filtering results
    ///   - sortBy: Optional array of sort descriptors
    /// - Returns: A configured FetchDescriptor
    func createFetchDescriptor(
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>]? = nil
    ) -> FetchDescriptor<T> {
        var descriptor = FetchDescriptor<T>()
        
        if let predicate = predicate {
            descriptor.predicate = predicate
        }
        
        if let sortBy = sortBy {
            descriptor.sortBy = sortBy
        }
        
        return descriptor
    }
    
    /// Executes a fetch using the provided descriptor and handles errors
    /// - Parameter descriptor: The fetch descriptor to use
    /// - Returns: The fetched results or an empty array if an error occurred
    func executeFetch(_ descriptor: FetchDescriptor<T>) -> [T] {
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching from \(String(describing: T.self)): \(error)")
            return []
        }
    }
    
    /// Saves changes to the model context
    /// - Returns: True if save was successful, false otherwise
    @discardableResult
    func saveContext() -> Bool {
        do {
            try modelContext.save()
            return true
        } catch {
            print("Error saving context in \(String(describing: T.self)) repository: \(error)")
            return false
        }
    }
    
    /// Saves an item to the repository.
    /// - Parameter item: The item to save (insert or update).
    /// - Throws: RepositoryError if the save operation fails.
    func save(_ item: T) throws {
        // SwiftData handles both insertion and updates automatically
        modelContext.insert(item)
        // Only attempt to save if there are actual changes
        guard modelContext.hasChanges else { return }
        do {
            try modelContext.save()
        } catch {
            throw RepositoryError.saveFailed(
                entityName: String(describing: T.self),
                underlyingError: error
            )
        }
    }
}

// Extension for TownLinkable items
extension BaseRepository where T: TownLinkable {
    /// Retrieves items by town ID using a SwiftData predicate
    /// - Parameter townId: The town ID to filter by
    /// - Returns: Array of items for the specified town
    func getByTownId(townId: UUID) -> [T] {
        let predicate = #Predicate<T> { item in
            item.townId == townId
        }
        let descriptor = createFetchDescriptor(predicate: predicate)
        return executeFetch(descriptor)
    }
}
