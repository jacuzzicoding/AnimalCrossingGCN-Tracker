// DataManager.swift
import Foundation
import SwiftData
import Combine
import SwiftUI
import Charts

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
    var analyticsService: AnalyticsService // Now public for direct access

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
        self.analyticsService = AnalyticsService(modelContext: modelContext, donationService: donationService)
        
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
            // Invalidate analytics cache when donation status changes
            analyticsService.invalidateCache()
        } else {
            donationService.unmarkItemAsDonated(fossil)
            analyticsService.invalidateCache()
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
            analyticsService.invalidateCache()
        } else {
            donationService.unmarkItemAsDonated(bug)
            analyticsService.invalidateCache()
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
            analyticsService.invalidateCache()
        } else {
            donationService.unmarkItemAsDonated(fish)
            analyticsService.invalidateCache()
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
            analyticsService.invalidateCache()
        } else {
            donationService.unmarkItemAsDonated(art)
            analyticsService.invalidateCache()
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
    
    // MARK: - Analytics
    
    /// Gets donation activity by month for the current town
    /// - Parameters:
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
    /// - Returns: Array of monthly donation activity data
    func getDonationActivityByMonth(startDate: Date? = nil, endDate: Date? = nil) -> [MonthlyDonationActivity] {
        guard let town = currentTown else { return [] }
        return analyticsService.getDonationActivityByMonth(town: town, startDate: startDate, endDate: endDate)
    }
    
    /// Gets category completion data for the current town
    /// - Returns: Category completion data
    func getCategoryCompletionData() -> CategoryCompletionData? {
        guard let town = currentTown else { return nil }
        return analyticsService.getCategoryCompletionData(town: town)
    }
    
    /// Gets seasonal data for the current town
    /// - Returns: Seasonal data
    func getSeasonalData() -> SeasonalData? {
        guard let town = currentTown else { return nil }
        return analyticsService.getSeasonalData(town: town)
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
    
    /// Generates test donation data with randomized donation dates for analytics testing
    func generateTestDonationData() {
        guard let town = currentTown else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
        
        // Function to generate a random date between two dates
        func randomDate(between startDate: Date, and endDate: Date) -> Date {
            let timeInterval = endDate.timeIntervalSince(startDate)
            let randomInterval = TimeInterval(arc4random_uniform(UInt32(timeInterval)))
            return startDate.addingTimeInterval(randomInterval)
        }
        
        // Function to generate a seasonal date (more donations in certain months)
        func seasonalDate() -> Date {
            let currentMonth = calendar.component(.month, from: now)
            let currentYear = calendar.component(.year, from: now)
            
            // Create seasonal bias with more donations in spring and fall (common collecting times)
            var targetMonth: Int
            let seasonBias = Int.random(in: 1...10)
            
            if seasonBias <= 3 { // 30% spring (March-May)
                targetMonth = Int.random(in: 3...5)
            } else if seasonBias <= 5 { // 20% summer (June-August)
                targetMonth = Int.random(in: 6...8)
            } else if seasonBias <= 8 { // 30% fall (September-November)
                targetMonth = Int.random(in: 9...11)
            } else { // 20% winter (December-February)
                targetMonth = [12, 1, 2].randomElement()!
            }
            
            // Adjust year if needed (for months before current month)
            let targetYear = (targetMonth > currentMonth) ? currentYear - 1 : currentYear
            
            // Create a date in the target month
            var dateComponents = DateComponents()
            dateComponents.year = targetYear
            dateComponents.month = targetMonth
            dateComponents.day = Int.random(in: 1...28) // Avoid month boundary issues
            
            return calendar.date(from: dateComponents) ?? now
        }
        
        // Function to randomly mark items as donated
        func randomlyDonate<T: CollectibleItem & PersistentModel>(items: [T], probability: Double, useSeasonalDates: Bool = false) {
            for item in items where !item.isDonated {
                if Double.random(in: 0...1) < probability {
                    // Set a random donation date using either completely random or seasonal logic
                    let randomDonationDate = useSeasonalDates ? seasonalDate() : randomDate(between: oneYearAgo, and: now)
                    
                    // Use DonationService to properly update the model in SwiftData
                    donationService.markItemAsDonated(item, withDate: randomDonationDate)
                }
            }
        }
        
        // Get all items for the current town
        let fossils = getFossilsForCurrentTown()
        let bugs = getBugsForCurrentTown()
        let fish = getFishForCurrentTown()
        let art = getArtForCurrentTown()
        
        // Randomly donate items with different probabilities for each category
        // And use seasonal dates for bugs and fish to create more realistic patterns
        randomlyDonate(items: fossils, probability: 0.7)  // 70% of fossils, random dates
        randomlyDonate(items: bugs, probability: 0.5, useSeasonalDates: true)  // 50% of bugs, seasonal dates
        randomlyDonate(items: fish, probability: 0.6, useSeasonalDates: true)  // 60% of fish, seasonal dates
        randomlyDonate(items: art, probability: 0.3)  // 30% of art, random dates
        
        // Update the town DTO
        updateTownDTO(town)
        
        // Clear analytics cache to ensure fresh data
        analyticsService.invalidateCache()
        
        // Print a summary of the generated data
        print("Generated test donation data:")
        print("- Fossils: \(fossils.filter { $0.isDonated }.count)/\(fossils.count)")
        print("- Bugs: \(bugs.filter { $0.isDonated }.count)/\(bugs.count)")
        print("- Fish: \(fish.filter { $0.isDonated }.count)/\(fish.count)")
        print("- Art: \(art.filter { $0.isDonated }.count)/\(art.count)")
        
        // Debug donation status
        debugDonationStatus()
    }
    
    /// Debugging function to check if donation dates are properly saved and retrieved
    func debugDonationStatus() {
        guard let town = currentTown else {
            print("DEBUG: No current town found")
            return
        }
        
        print("\n------------ DEBUG DONATION STATUS ------------")
        print("Current town: \(town.name)")
        
        // Check fossils
        let fossils = getFossilsForCurrentTown()
        print("Fossils total: \(fossils.count)")
        
        let donatedFossils = fossils.filter { $0.isDonated }
        print("Donated fossils: \(donatedFossils.count)")
        
        let fossilsWithDates = fossils.filter { $0.isDonated && $0.donationDate != nil }
        print("Fossils with dates: \(fossilsWithDates.count)")
        
        // Print some sample donation dates for debugging
        if !fossilsWithDates.isEmpty {
            for i in 0..<min(3, fossilsWithDates.count) {
                let fossil = fossilsWithDates[i]
                print("Fossil: \(fossil.name), Date: \(String(describing: fossil.donationDate))")
            }
        }
        
        // Check bugs
        let bugs = getBugsForCurrentTown()
        print("Bugs total: \(bugs.count)")
        
        let donatedBugs = bugs.filter { $0.isDonated }
        print("Donated bugs: \(donatedBugs.count)")
        
        let bugsWithDates = bugs.filter { $0.isDonated && $0.donationDate != nil }
        print("Bugs with dates: \(bugsWithDates.count)")
        
        // Check fish
        let fish = getFishForCurrentTown()
        print("Fish total: \(fish.count)")
        
        let donatedFish = fish.filter { $0.isDonated }
        print("Donated fish: \(donatedFish.count)")
        
        let fishWithDates = fish.filter { $0.isDonated && $0.donationDate != nil }
        print("Fish with dates: \(fishWithDates.count)")
        
        // Check art
        let art = getArtForCurrentTown()
        print("Art total: \(art.count)")
        
        let donatedArt = art.filter { $0.isDonated }
        print("Donated art: \(donatedArt.count)")
        
        let artWithDates = art.filter { $0.isDonated && $0.donationDate != nil }
        print("Art with dates: \(artWithDates.count)")
        
        // Check if analytics service is getting data
        let timelineData = analyticsService.getDonationActivityByMonth(town: town)
        print("\nAnalytics timeline data: \(timelineData.count) months")
        if !timelineData.isEmpty {
            for activity in timelineData {
                print("Month: \(activity.formattedMonth), Total: \(activity.totalCount), Fossils: \(activity.fossilCount), Bugs: \(activity.bugCount), Fish: \(activity.fishCount), Art: \(activity.artCount)")
            }
        }
        
        // Let's also check if the problem might be related to the gameRawValues array
        print("\nChecking model attribute values:")
        if let firstFossil = fossils.first {
            print("Fossil gameRawValues: \(firstFossil.gameRawValues)")
        }
        if let firstBug = bugs.first {
            print("Bug gameRawValues: \(firstBug.gameRawValues)")
        }
        print("-------------------------------------------\n")
    }

    /// Debugging method to check analytics data
    func debugAnalyticsData() {
        guard let town = currentTown else { 
            print("DEBUG: No current town selected")
            return 
        }
        
        // Get raw counts from repositories
        let allFossils = fossilRepository.getAll()
        let allBugs = bugRepository.getAll()
        let allFish = fishRepository.getAll()
        let allArt = artRepository.getAll()
        
        print("DEBUG: Total items in repositories - Fossils: \(allFossils.count), Bugs: \(allBugs.count), Fish: \(allFish.count), Art: \(allArt.count)")
        
        // Get town-specific items
        let townFossils = donationService.getFossilsForTown(town: town)
        let townBugs = donationService.getBugsForTown(town: town)
        let townFish = donationService.getFishForTown(town: town)
        let townArt = donationService.getArtForTown(town: town)
        
        print("DEBUG: Town items - Fossils: \(townFossils.count), Bugs: \(townBugs.count), Fish: \(townFish.count), Art: \(townArt.count)")
        
        // Check donations
        let donatedFossils = townFossils.filter { $0.isDonated }.count
        let donatedBugs = townBugs.filter { $0.isDonated }.count
        let donatedFish = townFish.filter { $0.isDonated }.count
        let donatedArt = townArt.filter { $0.isDonated }.count
        
        print("DEBUG: Donated items - Fossils: \(donatedFossils)/\(townFossils.count), Bugs: \(donatedBugs)/\(townBugs.count), Fish: \(donatedFish)/\(townFish.count), Art: \(donatedArt)/\(townArt.count)")
        
        // Check townId values - convert UUID to string for comparison
        if !townFossils.isEmpty {
            if let townId = townFossils[0].townId {
                print("DEBUG: Sample fossil townId: \(townId)")
            } else {
                print("DEBUG: Sample fossil townId is nil")
            }
            print("DEBUG: Current town ID: \(town.id.uuidString)")
        }
    }
}