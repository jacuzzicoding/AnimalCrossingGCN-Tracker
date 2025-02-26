// DataManager.swift
import Foundation
import SwiftData
import Combine
import SwiftUI

class DataManager: ObservableObject {
    // Access to the Model Context
    private var modelContext: ModelContext
    
    // Repositories
    private var townRepository: TownRepository
    private var fossilRepository: FossilRepository
    private var bugRepository: BugRepository
    private var fishRepository: FishRepository
    private var artRepository: ArtRepository

    // Published properties to notify views of changes
    @Published var currentTown: Town?

    // Initialize DataManager with repositories
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Initialize repositories
        self.townRepository = TownRepository(modelContext: modelContext)
        self.fossilRepository = FossilRepository(modelContext: modelContext)
        self.bugRepository = BugRepository(modelContext: modelContext)
        self.fishRepository = FishRepository(modelContext: modelContext)
        self.artRepository = ArtRepository(modelContext: modelContext)
        
        // Fetch current town
        fetchCurrentTown()
    }

    /// Fetches the current town using the TownRepository.
    /// If no town exists, it creates a default one.
    func fetchCurrentTown() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentTown = self.townRepository.ensureTownExists()
        }
    }

    /// Updates the town's name using the TownRepository.
    /// - Parameter newName: The new name for the town.
    func updateTownName(_ newName: String) {
        guard let town = currentTown else { return }
        
        if townRepository.updateName(town: town, newName: newName) {
            // Successfully updated
            print("Town name updated to: \(newName)")
        } else {
            // Update failed
            print("Failed to update town name")
        }
    }

    /// Adds a new town using the TownRepository.
    /// - Parameter town: The `Town` object to add.
    func addTown(_ town: Town) {
        townRepository.save(town)
        currentTown = town
    }

    /// Deletes the current town using the TownRepository.
    func deleteCurrentTown() {
        guard let town = currentTown else { return }
        townRepository.delete(town)
        fetchCurrentTown()
    }
    
    // MARK: - Fossil Methods
    
    /// Gets all fossils using the FossilRepository
    /// - Returns: Array of all fossils
    func getAllFossils() -> [Fossil] {
        return fossilRepository.getAll()
    }
    
    /// Gets fossils by donation status
    /// - Parameter donated: Whether the fossil has been donated
    /// - Returns: Array of fossils with the specified donation status
    func getFossilsByDonationStatus(donated: Bool) -> [Fossil] {
        return fossilRepository.getByDonationStatus(donated: donated)
    }
    
    /// Saves a fossil using the FossilRepository
    /// - Parameter fossil: The fossil to save
    func saveFossil(_ fossil: Fossil) {
        fossilRepository.save(fossil)
    }
    
    // MARK: - Bug Methods
    
    /// Gets all bugs using the BugRepository
    /// - Returns: Array of all bugs
    func getAllBugs() -> [Bug] {
        return bugRepository.getAll()
    }
    
    /// Gets bugs by donation status
    /// - Parameter donated: Whether the bug has been donated
    /// - Returns: Array of bugs with the specified donation status
    func getBugsByDonationStatus(donated: Bool) -> [Bug] {
        return bugRepository.getByDonationStatus(donated: donated)
    }
    
    /// Saves a bug using the BugRepository
    /// - Parameter bug: The bug to save
    func saveBug(_ bug: Bug) {
        bugRepository.save(bug)
    }
    
    // MARK: - Fish Methods
    
    /// Gets all fish using the FishRepository
    /// - Returns: Array of all fish
    func getAllFish() -> [Fish] {
        return fishRepository.getAll()
    }
    
    /// Gets fish by donation status
    /// - Parameter donated: Whether the fish has been donated
    /// - Returns: Array of fish with the specified donation status
    func getFishByDonationStatus(donated: Bool) -> [Fish] {
        return fishRepository.getByDonationStatus(donated: donated)
    }
    
    /// Saves a fish using the FishRepository
    /// - Parameter fish: The fish to save
    func saveFish(_ fish: Fish) {
        fishRepository.save(fish)
    }
    
    // MARK: - Art Methods
    
    /// Gets all art pieces using the ArtRepository
    /// - Returns: Array of all art pieces
    func getAllArt() -> [Art] {
        return artRepository.getAll()
    }
    
    /// Gets art pieces by donation status
    /// - Parameter donated: Whether the art piece has been donated
    /// - Returns: Array of art pieces with the specified donation status
    func getArtByDonationStatus(donated: Bool) -> [Art] {
        return artRepository.getByDonationStatus(donated: donated)
    }
    
    /// Saves an art piece using the ArtRepository
    /// - Parameter art: The art piece to save
    func saveArt(_ art: Art) {
        artRepository.save(art)
    }
    
    // MARK: - Game-specific Methods
    
    /// Gets collectible items for a specific game
    /// - Parameter game: The game to filter by
    /// - Returns: A dictionary containing all collectible types for the specified game
    func getItemsForGame(game: ACGame) -> [String: Any] {
        return [
            "fossils": fossilRepository.getByGame(game),
            "bugs": bugRepository.getByGame(game),
            "fish": fishRepository.getByGame(game),
            "art": artRepository.getByGame(game)
        ]
    }
}