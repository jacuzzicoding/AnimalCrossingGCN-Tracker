// DataManager.swift
import Foundation
import SwiftData
import Combine
import SwiftUI

class DataManager: ObservableObject {
    // Access to the Model Context
    private var modelContext: ModelContext

    // Published properties to notify views of changes
    @Published var currentTown: Town?

    // Initialize DataManager and fetch the current town
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchCurrentTown()
    }

    /// Fetches the current town from the persistent store.
    /// If no town exists, it creates a default one.
    func fetchCurrentTown() {
        // Create a basic fetch descriptor for Town
        let descriptor = FetchDescriptor<Town>()

        do {
            let towns = try modelContext.fetch(descriptor)
            if let town = towns.first {
                DispatchQueue.main.async {
                    self.currentTown = town
                }
            } else {
                // No town exists; create a default one
                let defaultTown = Town(name: "My Town")
                modelContext.insert(defaultTown)
                try modelContext.save()
                DispatchQueue.main.async {
                    self.currentTown = defaultTown
                }
            }
        } catch {
            print("Error fetching or creating Town: \(error)")
        }
    }


    /// Updates the town's name.
    /// - Parameter newName: The new name for the town.
    func updateTownName(_ newName: String) {
        guard let town = currentTown else { return }
        town.name = newName
        
        do {
            try modelContext.save()
        } catch {
            print("Error updating town name: \(error)")
        }
    }

    /// Adds a new town. (Optional: If you plan to support multiple towns in the future)
    /// - Parameter town: The `Town` object to add.
    func addTown(_ town: Town) {
        modelContext.insert(town)
        
        do {
            try modelContext.save()
            currentTown = town
        } catch {
            print("Error adding new town: \(error)")
        }
    }

    /// Deletes the current town. (Optional: If you plan to support multiple towns)
    func deleteCurrentTown() {
        guard let town = currentTown else { return }
        modelContext.delete(town)
        
        do {
            try modelContext.save()
            fetchCurrentTown()
        } catch {
            print("Error deleting town: \(error)")
        }
    }
}
