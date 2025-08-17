// DataManager.swift
import Foundation
import SwiftData
import Combine
import SwiftUI
import Charts

// MARK: - Import all required types and dependencies

// Since we need to import the models, services, and protocols, let me check what's available

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
    private let donationService: DonationServiceProtocol
    var analyticsService: AnalyticsServiceProtocol // Now public for direct access
    private let globalSearchService: GlobalSearchServiceProtocol
    let exportService: ExportServiceProtocol // Public export service

    // Published properties to notify views of changes
    @Published var currentTown: Town?
    @Published var currentTownDTO: TownDTO?

    // Initialize DataManager with repositories and services
    init(
        modelContext: ModelContext,
        donationService: DonationServiceProtocol? = nil,
        analyticsService: AnalyticsServiceProtocol? = nil,
        exportService: ExportServiceProtocol? = nil,
        globalSearchService: GlobalSearchServiceProtocol? = nil
    ) {
        self.modelContext = modelContext
        
        // Initialize repositories
        self.townRepository = TownRepository(modelContext: modelContext)
        self.fossilRepository = FossilRepository(modelContext: modelContext)
        self.bugRepository = BugRepository(modelContext: modelContext)
        self.fishRepository = FishRepository(modelContext: modelContext)
        self.artRepository = ArtRepository(modelContext: modelContext)
        
        // Initialize services
        self.donationService = donationService ?? DonationServiceImpl(modelContext: modelContext)
        self.analyticsService = analyticsService ?? AnalyticsServiceImpl(modelContext: modelContext, donationService: self.donationService)
        self.exportService = exportService ?? ExportServiceImpl()
        self.globalSearchService = globalSearchService ?? GlobalSearchServiceImpl(modelContext: modelContext)
        
        // Fetch current town
        fetchCurrentTown()
    }

    /// Saves the current model context if there are changes.
    private func saveContext() {
        // Check if there are changes before attempting to save
        if modelContext.hasChanges {
            do {
                try modelContext.save()
                print("DataManager: Context saved successfully.")
            } catch {
                // Log the error or update an error state for the UI
                print("DataManager: Failed to save context - \(error)")
            }
        } else {
            print("DataManager: No changes detected in context, skipping save.")
        }
    }

    /// Fetches the current town using the TownRepository.
    /// If no town exists, it creates a default one.
    func fetchCurrentTown() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentTown = self.townRepository.ensureTownExists()
            if let town = self.currentTown {
                // Ensure all collectible items are properly linked to the town
                self.ensureItemsAreLinkedToCurrentTown()
                self.updateTownDTO(town)
            }
        }
    }
    
    /// Updates the town DTO with current progress information
    /// - Parameter town: The town to update the DTO for
    private func updateTownDTO(_ town: Town) {
        // Safely fetch progress values
        let fossilProgress: Double
        do { fossilProgress = try donationService.getFossilProgressForTown(town: town) }
        catch { print("Error calculating fossil progress: \(error)"); fossilProgress = 0.0 }
        let bugProgress: Double
        do { bugProgress = try donationService.getBugProgressForTown(town: town) }
        catch { print("Error calculating bug progress: \(error)"); bugProgress = 0.0 }
        let fishProgress: Double
        do { fishProgress = try donationService.getFishProgressForTown(town: town) }
        catch { print("Error calculating fish progress: \(error)"); fishProgress = 0.0 }
        let artProgress: Double
        do { artProgress = try donationService.getArtProgressForTown(town: town) }
        catch { print("Error calculating art progress: \(error)"); artProgress = 0.0 }
        let totalProgress: Double
        do { totalProgress = try donationService.getTotalProgressForTown(town: town) }
        catch { print("Error calculating total progress: \(error)"); totalProgress = 0.0 }
        
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
        
        // Unlink all collectibles with error handling
        do {
            let fossils = try donationService.getFossilsForTown(town: town)
            fossils.forEach { fossil in
                do { try donationService.unlinkFossilFromTown(fossil: fossil) }
                catch { print("Error unlinking fossil: \(error)") }
            }
        } catch {
            print("Error fetching fossils for unlink: \(error)") }
        do {
            let bugs = try donationService.getBugsForTown(town: town)
            bugs.forEach { bug in
                do { try donationService.unlinkBugFromTown(bug: bug) }
                catch { print("Error unlinking bug: \(error)") }
            }
        } catch {
            print("Error fetching bugs for unlink: \(error)") }
        do {
            let fish = try donationService.getFishForTown(town: town)
            fish.forEach { fish in
                do { try donationService.unlinkFishFromTown(fish: fish) }
                catch { print("Error unlinking fish: \(error)") }
            }
        } catch {
            print("Error fetching fish for unlink: \(error)") }
        do {
            let art = try donationService.getArtForTown(town: town)
            art.forEach { art in
                do { try donationService.unlinkArtFromTown(art: art) }
                catch { print("Error unlinking art: \(error)") }
            }
        } catch {
            print("Error fetching art for unlink: \(error)") }
        
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
        do { return try donationService.getFossilsForTown(town: town) }
        catch { print("Error fetching fossils for town: \(error)"); return [] }
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
        do {
            if isDonated {
                try donationService.markItemAsDonated(fossil)
                analyticsService.invalidateCache()
            } else {
                try donationService.unmarkItemAsDonated(fossil)
                analyticsService.invalidateCache()
            }
            // Explicitly save the context after updating
            saveContext()
        } catch {
            print("Error updating fossil donation status: \(error)")
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
        do { try donationService.linkFossilToTown(fossil: fossil, town: town) }
        catch { print("Error linking fossil to town: \(error)") }
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
        do { return try donationService.getBugsForTown(town: town) }
        catch { print("Error fetching bugs for town: \(error)"); return [] }
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
        do {
            if isDonated {
                try donationService.markItemAsDonated(bug)
                analyticsService.invalidateCache()
            } else {
                try donationService.unmarkItemAsDonated(bug)
                analyticsService.invalidateCache()
            }
            // Explicitly save the context after updating
            saveContext()
        } catch {
            print("Error updating bug donation status: \(error)")
        }
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links a bug to the current town
    /// - Parameter bug: The bug to link
    func linkBugToCurrentTown(_ bug: Bug) {
        guard let town = currentTown else { return }
        do { try donationService.linkBugToTown(bug: bug, town: town) }
        catch { print("Error linking bug to town: \(error)") }
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
        do { return try donationService.getFishForTown(town: town) }
        catch { print("Error fetching fish for town: \(error)"); return [] }
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
        do {
            if isDonated {
                try donationService.markItemAsDonated(fish)
                analyticsService.invalidateCache()
            } else {
                try donationService.unmarkItemAsDonated(fish)
                analyticsService.invalidateCache()
            }
            // Explicitly save the context after updating
            saveContext()
        } catch {
            print("Error updating fish donation status: \(error)")
        }
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links a fish to the current town
    /// - Parameter fish: The fish to link
    func linkFishToCurrentTown(_ fish: Fish) {
        guard let town = currentTown else { return }
        do { try donationService.linkFishToTown(fish: fish, town: town) }
        catch { print("Error linking fish to town: \(error)") }
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
        do { return try donationService.getArtForTown(town: town) }
        catch { print("Error fetching art for town: \(error)"); return [] }
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
        do {
            if isDonated {
                try donationService.markItemAsDonated(art)
                analyticsService.invalidateCache()
            } else {
                try donationService.unmarkItemAsDonated(art)
                analyticsService.invalidateCache()
            }
            // Explicitly save the context after updating
            saveContext()
        } catch {
            print("Error updating art donation status: \(error)")
        }
        if let town = currentTown {
            updateTownDTO(town)
        }
    }
    
    /// Links an art piece to the current town
    /// - Parameter art: The art piece to link
    func linkArtToCurrentTown(_ art: Art) {
        guard let town = currentTown else { return }
        do { try donationService.linkArtToTown(art: art, town: town) }
        catch { print("Error linking art to town: \(error)") }
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
    
    // MARK: - Analytics
    
    /// Gets donation activity by month for the current town
    /// - Parameters:
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
    /// - Returns: Array of monthly donation activity data
    func getDonationActivityByMonth(startDate: Date? = nil, endDate: Date? = nil) throws -> [MonthlyDonationActivity] {
        guard let town = currentTown else {
            throw ServiceError.noTownSelected(operation: "getDonationActivityByMonth")
        }
        return try analyticsService.getDonationActivityByMonth(town: town, startDate: startDate, endDate: endDate)
    }

    /// Gets category completion data for the current town
    /// - Returns: Category completion data
    func getCategoryCompletionData() throws -> CategoryCompletionData? {
        guard let town = currentTown else { return nil }
        return try analyticsService.getCategoryCompletionData(town: town)
    }

    /// Gets seasonal data for the current town
    /// - Returns: Seasonal data
    func getSeasonalData() throws -> SeasonalData? {
        guard let town = currentTown else { return nil }
        return try analyticsService.getSeasonalData(town: town)
    }
    
    // MARK: - Progress Tracking
    
    /// Gets the overall donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        do { return try donationService.getTotalProgressForTown(town: town) }
        catch { print("Error fetching total progress: \(error)"); return 0.0 }
    }
    
    /// Gets fossil donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownFossilProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        do { return try donationService.getFossilProgressForTown(town: town) }
        catch { print("Error fetching fossil progress: \(error)"); return 0.0 }
    }
    
    /// Gets bug donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownBugProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        do { return try donationService.getBugProgressForTown(town: town) }
        catch { print("Error fetching bug progress: \(error)"); return 0.0 }
    }
    
    /// Gets fish donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownFishProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        do { return try donationService.getFishProgressForTown(town: town) }
        catch { print("Error fetching fish progress: \(error)"); return 0.0 }
    }
    
    /// Gets art donation progress for the current town
    /// - Returns: A percentage value between 0 and 1
    func getCurrentTownArtProgress() -> Double {
        guard let town = currentTown else { return 0.0 }
        do { return try donationService.getArtProgressForTown(town: town) }
        catch { print("Error fetching art progress: \(error)"); return 0.0 }
    }
    
    // MARK: - Data Setup
    
    /// Ensures that all collectible items are properly linked to the current town
    /// This method checks for any items that aren't linked to a town and links them to the current town
    private func ensureItemsAreLinkedToCurrentTown() {
        guard let town = currentTown else { return }
        
        // Link any unlinked fossils
        let unlinkdFossils = fossilRepository.getAll().filter { $0.townId == nil }
        for fossil in unlinkdFossils {
            do {
                try donationService.linkFossilToTown(fossil: fossil, town: town)
            } catch {
                print("Error linking fossil to current town: \(error)")
            }
        }
        
        // Link any unlinked bugs
        let unlinkedBugs = bugRepository.getAll().filter { $0.townId == nil }
        for bug in unlinkedBugs {
            do {
                try donationService.linkBugToTown(bug: bug, town: town)
            } catch {
                print("Error linking bug to current town: \(error)")
            }
        }
        
        // Link any unlinked fish
        let unlinkedFish = fishRepository.getAll().filter { $0.townId == nil }
        for fish in unlinkedFish {
            do {
                try donationService.linkFishToTown(fish: fish, town: town)
            } catch {
                print("Error linking fish to current town: \(error)")
            }
        }
        
        // Link any unlinked art
        let unlinkedArt = artRepository.getAll().filter { $0.townId == nil }
        for art in unlinkedArt {
            do {
                try donationService.linkArtToTown(art: art, town: town)
            } catch {
                print("Error linking art to current town: \(error)")
            }
        }
    }

    /// Gets default fossils for initialization
    /// - Returns: Array of default fossil objects
    private func getDefaultFossils() -> [Fossil] {
        return [
            // T. Rex
            Fossil(name: "T. Rex", part: "Skull", isDonated: false, games: [.ACGCN]),
            Fossil(name: "T. Rex", part: "Torso", isDonated: false, games: [.ACGCN]),
            Fossil(name: "T. Rex", part: "Tail", isDonated: false, games: [.ACGCN]),
            
            // Triceratops
            Fossil(name: "Triceratops", part: "Skull", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Triceratops", part: "Torso", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Triceratops", part: "Tail", isDonated: false, games: [.ACGCN]),
            
            // Stegosaurus
            Fossil(name: "Stegosaurus", part: "Skull", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Stegosaurus", part: "Torso", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Stegosaurus", part: "Tail", isDonated: false, games: [.ACGCN]),
            
            // Mammoth
            Fossil(name: "Mammoth", part: "Skull", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Mammoth", part: "Torso", isDonated: false, games: [.ACGCN]),
            Fossil(name: "Mammoth", part: "Tail", isDonated: false, games: [.ACGCN])
        ]
    }
    
    // MARK: - Global Search Methods
    
    /// Searches across all categories using the global search service
    /// - Parameters:
    ///   - query: The search text to use
    ///   - townId: Optional town ID to filter results
    /// - Returns: Global search results containing items from all categories
    func searchAllCategories(query: String, townId: UUID? = nil) -> GlobalSearchResults {
        return globalSearchService.searchAllCategories(query: query, townId: townId)
    }
    
    /// Gets the search history from the global search service
    /// - Returns: Array of recent search strings
    func getSearchHistory() -> [String] {
        return globalSearchService.getSearchHistory()
    }
    
    /// Clears the search history using the global search service
    func clearSearchHistory() {
        globalSearchService.clearSearchHistory()
    }
}