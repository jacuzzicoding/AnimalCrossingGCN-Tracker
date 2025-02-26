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
    
    // Services
    private var donationService: DonationService

    // Published properties to notify views of changes
    @Published var currentTown: Town?
    @Published var currentTownDTO: TownDTO?

    // Initialize DataManager with repositories and services
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Initialize repositories
        self.townRepository = TownRepository(modelContext: modelContext)
        self.fossilRepository = FossilRepository(modelContext: modelContext)
        self.bugRepository = BugRepository(modelContext: modelContext)
        self.fishRepository = FishRepository(modelContext: modelContext)
        self.artRepository = ArtRepository(modelContext: modelContext)
        
        // Initialize services
        self.donationService = DonationService(modelContext: modelContext)
        
        // Fetch current town
        fetchCurrentTown()
    }

    /// Fetches the current town using the TownRepository.
    /// If no town exists, it creates a default one.
    func fetchCurrentTown() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentTown = self.townRepository.ensureTownExists()
            if let town = self.currentTown {
                self.updateTownDTO(town)
            }
        }
    }
    
    /// Updates the town DTO with current progress information
    /// - Parameter town: The town to update the DTO for
    private func updateTownDTO(_ town: Town) {
        let fossilProgress = donationService.getFossilProgressForTown(town: town)
        let bugProgress = donationService.getBugProgressForTown(town: town)
        let fishProgress = donationService.getFishProgressForTown(town: town)
        let artProgress = donationService.getArtProgressForTown(town: town)
        let totalProgress = donationService.getTotalProgressForTown(town: town)
        
        self.currentTownDTO = TownDTO(
            from: town,
            fossilProgress: fossilProgress,
            bugProgress: bugProgress,
            fishProgress: fishProgress,
            artProgress: artProgress,
            totalProgress: totalProgress
        )
    }

    /// Updates the town's name using the TownRepository.
    /// - Parameter newName: The new name for the town.
    func updateTownName(_ newName: String) {
        guard let town = currentTown else { return }
        
        if townRepository.updateName(town: town, newName: newName) {
            // Successfully updated
            print("Town name updated to: \(newName)")
            updateTownDTO(town)
        } else {
            // Update failed
            print("Failed to update town name")
        }
    }
    
    /// Updates the town's player name
    /// - Parameter playerName: The new player name
    func updatePlayerName(_ playerName: String) {
        guard let town = currentTown else { return }
        
        town.playerName = playerName
        townRepository.save(town)
        updateTownDTO(town)
    }
    
    /// Updates the town's game version
    /// - Parameter game: The new game version
    func updateGameVersion(_ game: ACGame) {
        guard let town = currentTown else { return }
        
        town.game = game
        townRepository.save(town)
        updateTownDTO(town)
    }

    /// Adds a new town using the TownRepository.
    /// - Parameter town: The `Town` object to add.
    func addTown(_ town: Town) {
        townRepository.save(town)
        currentTown = town
        updateTownDTO(town)
    }

    /// Deletes the current town using the TownRepository.
    func deleteCurrentTown() {
        guard let town = currentTown else { return }
        
        // Unlink all collectibles from this town
        donationService.getFossilsForTown(town: town).forEach { fossil in
            donationService.unlinkFossilFromTown(fossil: fossil)
        }
        
        donationService.getBugsForTown(town: town).forEach { bug in
            donationService.unlinkBugFromTown(bug: bug)
        }
        
        donationService.getFishForTown(town: town).forEach { fish in
            donationService.unlinkFishFromTown(fish: fish)
        }
        
        donationService.getArtForTown(town: town).forEach { art in
            donationService.unlinkArtFromTown(art: art)
        }
        
        // Delete the town
        townRepository.delete(town)
        fetchCurrentTown()
    }
    
    // MARK: - Fossil Methods
    
    /// Gets all fossils using the FossilRepository
    /// - Returns: Array of all fossils
    func getAllFossils() -> [Fossil] {
        return fossilRepository.getAll()
    }
    
    /// Gets fossils for the current town
    /// - Returns: Array of fossils linked to the current town
    func getFossilsForCurrentTown() -> [Fossil] {
        guard let town = currentTown else { return [] }
        return donationService.getFossilsForTown(town: town)
    }
    
    /// Gets DTOs for fossils in the current town
    /// - Returns: Array of fossil DTOs
    func getFossilDTOsForCurrentTown() -> [FossilDTO] {
        getFossilsForCurrentTown().map { FossilDTO(from: $0) }
    }
    
    /// Gets fossils by donation status for the current town
    /// - Parameter donated: Whether the fossil has been donated
    /// - Returns: Array of fossils with the specified donation status
    func getFossilsByDonationStatus(donated: Bool) -> [Fossil] {
        let fossils = getFossilsForCurrentTown()
        return fossils.filter { $0.isDonated == donated }
    }
    
    /// Updates a fossil's donation status
    /// - Parameters:
    ///   - fossil: The fossil to update
    ///   - isDonated: The new donation status
    func updateFossilDonationStatus(_ fossil: Fossil, isDonated: Bool) {
        if isDonated {
            donationService.markItemAsDonated(fossil)
        } else {
            donationService.unmarkItemAsDonated(fossil)
        }
        
        // Update the town progress
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links a fossil to the current town
    /// - Parameter fossil: The fossil to link
    func linkFossilToCurrentTown(_ fossil: Fossil) {
        guard let town = currentTown else { return }
        donationService.linkFossilToTown(fossil: fossil, town: town)
        updateTownDTO(town)
    }
    
    // MARK: - Bug Methods
    
    /// Gets all bugs using the BugRepository
    /// - Returns: Array of all bugs
    func getAllBugs() -> [Bug] {
        return bugRepository.getAll()
    }
    
    /// Gets bugs for the current town
    /// - Returns: Array of bugs linked to the current town
    func getBugsForCurrentTown() -> [Bug] {
        guard let town = currentTown else { return [] }
        return donationService.getBugsForTown(town: town)
    }
    
    /// Gets DTOs for bugs in the current town
    /// - Returns: Array of bug DTOs
    func getBugDTOsForCurrentTown() -> [BugDTO] {
        getBugsForCurrentTown().map { BugDTO(from: $0) }
    }
    
    /// Gets bugs by donation status for the current town
    /// - Parameter donated: Whether the bug has been donated
    /// - Returns: Array of bugs with the specified donation status
    func getBugsByDonationStatus(donated: Bool) -> [Bug] {
        let bugs = getBugsForCurrentTown()
        return bugs.filter { $0.isDonated == donated }
    }
    
    /// Updates a bug's donation status
    /// - Parameters:
    ///   - bug: The bug to update
    ///   - isDonated: The new donation status
    func updateBugDonationStatus(_ bug: Bug, isDonated: Bool) {
        if isDonated {
            donationService.markItemAsDonated(bug)
        } else {
            donationService.unmarkItemAsDonated(bug)
        }
        
        // Update the town progress
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links a bug to the current town
    /// - Parameter bug: The bug to link
    func linkBugToCurrentTown(_ bug: Bug) {
        guard let town = currentTown else { return }
        donationService.linkBugToTown(bug: bug, town: town)
        updateTownDTO(town)
    }
    
    // MARK: - Fish Methods
    
    /// Gets all fish using the FishRepository
    /// - Returns: Array of all fish
    func getAllFish() -> [Fish] {
        return fishRepository.getAll()
    }
    
    /// Gets fish for the current town
    /// - Returns: Array of fish linked to the current town
    func getFishForCurrentTown() -> [Fish] {
        guard let town = currentTown else { return [] }
        return donationService.getFishForTown(town: town)
    }
    
    /// Gets DTOs for fish in the current town
    /// - Returns: Array of fish DTOs
    func getFishDTOsForCurrentTown() -> [FishDTO] {
        getFishForCurrentTown().map { FishDTO(from: $0) }
    }
    
    /// Gets fish by donation status for the current town
    /// - Parameter donated: Whether the fish has been donated
    /// - Returns: Array of fish with the specified donation status
    func getFishByDonationStatus(donated: Bool) -> [Fish] {
        let fish = getFishForCurrentTown()
        return fish.filter { $0.isDonated == donated }
    }
    
    /// Updates a fish's donation status
    /// - Parameters:
    ///   - fish: The fish to update
    ///   - isDonated: The new donation status
    func updateFishDonationStatus(_ fish: Fish, isDonated: Bool) {
        if isDonated {
            donationService.markItemAsDonated(fish)
        } else {
            donationService.unmarkItemAsDonated(fish)
        }
        
        // Update the town progress
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links a fish to the current town
    /// - Parameter fish: The fish to link
    func linkFishToCurrentTown(_ fish: Fish) {
        guard let town = currentTown else { return }
        donationService.linkFishToTown(fish: fish, town: town)
        updateTownDTO(town)
    }
    
    // MARK: - Art Methods
    
    /// Gets all art pieces using the ArtRepository
    /// - Returns: Array of all art pieces
    func getAllArt() -> [Art] {
        return artRepository.getAll()
    }
    
    /// Gets art pieces for the current town
    /// - Returns: Array of art pieces linked to the current town
    func getArtForCurrentTown() -> [Art] {
        guard let town = currentTown else { return [] }
        return donationService.getArtForTown(town: town)
    }
    
    /// Gets DTOs for art pieces in the current town
    /// - Returns: Array of art DTOs
    func getArtDTOsForCurrentTown() -> [ArtDTO] {
        getArtForCurrentTown().map { ArtDTO(from: $0) }
    }
    
    /// Gets art pieces by donation status for the current town
    /// - Parameter donated: Whether the art piece has been donated
    /// - Returns: Array of art pieces with the specified donation status
    func getArtByDonationStatus(donated: Bool) -> [Art] {
        let artPieces = getArtForCurrentTown()
        return artPieces.filter { $0.isDonated == donated }
    }
    
    /// Updates an art piece's donation status
    /// - Parameters:
    ///   - art: The art piece to update
    ///   - isDonated: The new donation status
    func updateArtDonationStatus(_ art: Art, isDonated: Bool) {
        if isDonated {
            donationService.markItemAsDonated(art)
        } else {
            donationService.unmarkItemAsDonated(art)
        }
        
        // Update the town progress
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links an art piece to the current town
    /// - Parameter art: The art piece to link
    func linkArtToCurrentTown(_ art: Art) {
        guard let town = currentTown else { return }
        donationService.linkArtToTown(art: art, town: town)
        updateTownDTO(town)
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
    
    // MARK: - Progress Tracking
    
    /// Gets the overall donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        return donationService.getTotalProgressForTown(town: town)
    }
    
    /// Gets fossil donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownFossilProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        return donationService.getFossilProgressForTown(town: town)
    }
    
    /// Gets bug donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownBugProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        return donationService.getBugProgressForTown(town: town)
    }
    
    /// Gets fish donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownFishProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        return donationService.getFishProgressForTown(town: town)
    }
    
    /// Gets art donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownArtProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        return donationService.getArtProgressForTown(town: town)
    }
    
    // MARK: - Data Setup
    
    /// Initializes a town with default collectibles for a specific game
    /// - Parameters:
    ///   - town: The town to initialize
    ///   - game: The game to use for initializing collectibles
    func initializeTownWithDefaultItems(_ town: Town, game: ACGame) {
        // Create and link default fossils
        for fossil in getDefaultFossils().filter({ $0.games.contains(game) }) {
            fossil.townId = town.id
            fossilRepository.save(fossil)
        }
        
        // Create and link default bugs
        for bug in getDefaultBugs().filter({ $0.games.contains(game) }) {
            bug.townId = town.id
            bugRepository.save(bug)
        }
        
        // Create and link default fish
        for fish in getDefaultFish().filter({ $0.games.contains(game) }) {
            fish.townId = town.id
            fishRepository.save(fish)
        }
        
        // Create and link default art
        for art in getDefaultArt().filter({ $0.games.contains(game) }) {
            art.townId = town.id
            artRepository.save(art)
        }
        
        // Update town DTO with progress info
        updateTownDTO(town)
    }
}