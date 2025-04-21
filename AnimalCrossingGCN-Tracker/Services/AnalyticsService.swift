//
//  AnalyticsService.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/26/25.
//

import Foundation
import SwiftData

/// Service for processing and transforming data for analytics features
class AnalyticsService {
    private let modelContext: ModelContext
    private let donationService: DonationService
    private let fossilRepository: FossilRepository
    private let bugRepository: BugRepository
    private let fishRepository: FishRepository
    private let artRepository: ArtRepository
    
    // Caching properties
    private var cachedTimelineData: [String: [MonthlyDonationActivity]] = [:]
    private var cachedCompletionData: [String: CategoryCompletionData] = [:]
    private var cachedSeasonalData: [String: SeasonalData] = [:]
    private var lastCacheTime: Date?
    private let cacheExpirationInterval: TimeInterval = 300 // 5 minutes
    
    /// Initializes the service with required dependencies
    /// - Parameters:
    ///   - modelContext: The SwiftData context to use
    ///   - donationService: The donation service for access to donation data
    init(modelContext: ModelContext, donationService: DonationService) {
        self.modelContext = modelContext
        self.donationService = donationService
        self.fossilRepository = FossilRepository(modelContext: modelContext)
        self.bugRepository = BugRepository(modelContext: modelContext)
        self.fishRepository = FishRepository(modelContext: modelContext)
        self.artRepository = ArtRepository(modelContext: modelContext)
    }
    
    // MARK: - Cache Management
    
    /// Invalidates the analytics cache
    func invalidateCache() {
        cachedTimelineData.removeAll()
        cachedCompletionData.removeAll()
        cachedSeasonalData.removeAll()
        lastCacheTime = nil
    }
    
    /// Checks if the cache is still valid
    private func isCacheValid() -> Bool {
        guard let lastCacheTime = lastCacheTime else { return false }
        return Date().timeIntervalSince(lastCacheTime) < cacheExpirationInterval
    }
    
    // MARK: - Timeline Analytics
    
    /// Get donation activity by month for a specific town
    /// - Parameters:
    ///   - town: The town to analyze
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
    /// - Returns: Array of monthly donation activity data
    func getDonationActivityByMonth(town: Town, startDate: Date? = nil, endDate: Date? = nil) throws -> [MonthlyDonationActivity] {
        let cacheKey = "\(town.id)_\(startDate?.description ?? "nil")_\(endDate?.description ?? "nil")"
        
        // Check cache first
        if isCacheValid(), let cachedData = cachedTimelineData[cacheKey] {
            return cachedData
        }
        
        do {
            let fossils = try donationService.getFossilsForTown(town: town).filter { $0.isDonated }
            let bugs = try donationService.getBugsForTown(town: town).filter { $0.isDonated }
            let fish = try donationService.getFishForTown(town: town).filter { $0.isDonated }
            let artPieces = try donationService.getArtForTown(town: town).filter { $0.isDonated }
            
            var monthlyActivity: [String: MonthlyDonationActivity] = [:]
            processMonthlyDonations(fossils, category: .fossil, into: &monthlyActivity, startDate: startDate, endDate: endDate)
            processMonthlyDonations(bugs, category: .bug, into: &monthlyActivity, startDate: startDate, endDate: endDate)
            processMonthlyDonations(fish, category: .fish, into: &monthlyActivity, startDate: startDate, endDate: endDate)
            processMonthlyDonations(artPieces, category: .art, into: &monthlyActivity, startDate: startDate, endDate: endDate)
            
            if monthlyActivity.isEmpty && (fossils.count + bugs.count + fish.count + artPieces.count > 0) {
                let today = Date()
                let calendar = Calendar.current
                let month = calendar.startOfDay(for: calendar.date(from: DateComponents(
                    year: calendar.component(.year, from: today),
                    month: calendar.component(.month, from: today),
                    day: 1
                ))!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM"
                let monthStr = dateFormatter.string(from: month)
                monthlyActivity[monthStr] = MonthlyDonationActivity(
                    month: month,
                    fossilCount: fossils.count,
                    bugCount: bugs.count,
                    fishCount: fish.count,
                    artCount: artPieces.count,
                    totalCount: fossils.count + bugs.count + fish.count + artPieces.count
                )
            }
            let result = monthlyActivity.values.sorted { $0.month < $1.month }
            cachedTimelineData[cacheKey] = result
            lastCacheTime = Date()
            return result
        } catch let error as ServiceError {
            throw ServiceError.analyticsProcessingFailed(operationType: "getDonationActivityByMonth", reason: "Service error", underlyingError: error)
        } catch {
            throw ServiceError.analyticsProcessingFailed(operationType: "getDonationActivityByMonth", reason: "Unknown error", underlyingError: error)
        }
    }
    
    /// Process donations into monthly activity, handling items that may not have dates
    private func processMonthlyDonations<T: CollectibleItem & DonationTimestampable & PersistentModel>(
        _ items: [T],
        category: DonationCategory,
        into monthlyActivity: inout [String: MonthlyDonationActivity],
        startDate: Date?,
        endDate: Date?
    ) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        // First try to use items with actual donation dates
        for item in items {
            if let donationDate = item.donationDate {
                // Check date range if specified
                if let startDate = startDate, donationDate < startDate { continue }
                if let endDate = endDate, donationDate > endDate { continue }
                
                let monthStr = dateFormatter.string(from: donationDate)
                let month = calendar.startOfDay(for: calendar.date(from: DateComponents(
                    year: calendar.component(.year, from: donationDate),
                    month: calendar.component(.month, from: donationDate),
                    day: 1
                ))!)
                
                if var activity = monthlyActivity[monthStr] {
                    // Update existing month
                    switch category {
                    case .fossil: activity.fossilCount += 1
                    case .bug: activity.bugCount += 1
                    case .fish: activity.fishCount += 1
                    case .art: activity.artCount += 1
                    }
                    activity.totalCount += 1
                    monthlyActivity[monthStr] = activity
                } else {
                    // Create new month entry
                    var activity = MonthlyDonationActivity(month: month, fossilCount: 0, bugCount: 0, fishCount: 0, artCount: 0)
                    switch category {
                    case .fossil: activity.fossilCount = 1
                    case .bug: activity.bugCount = 1
                    case .fish: activity.fishCount = 1
                    case .art: activity.artCount = 1
                    }
                    activity.totalCount = 1
                    monthlyActivity[monthStr] = activity
                }
            }
        }
        
        // If we didn't add any items with dates, but we have donated items without dates,
        // put them in the current month as a fallback
        let itemsWithDates = items.filter { $0.donationDate != nil }
        if itemsWithDates.count == 0 && items.count > 0 {
            let today = Date()
            let monthStr = dateFormatter.string(from: today)
            let month = calendar.startOfDay(for: calendar.date(from: DateComponents(
                year: calendar.component(.year, from: today),
                month: calendar.component(.month, from: today),
                day: 1
            ))!)
            
            if var activity = monthlyActivity[monthStr] {
                // Add to existing month
                switch category {
                case .fossil: activity.fossilCount += items.count
                case .bug: activity.bugCount += items.count
                case .fish: activity.fishCount += items.count
                case .art: activity.artCount += items.count
                }
                activity.totalCount += items.count
                monthlyActivity[monthStr] = activity
            } else {
                // Create new month
                var activity = MonthlyDonationActivity(month: month, fossilCount: 0, bugCount: 0, fishCount: 0, artCount: 0)
                switch category {
                case .fossil: activity.fossilCount = items.count
                case .bug: activity.bugCount = items.count
                case .fish: activity.fishCount = items.count
                case .art: activity.artCount = items.count
                }
                activity.totalCount = items.count
                monthlyActivity[monthStr] = activity
            }
        }
    }
    
    // MARK: - Category Analysis
    
    /// Get category completion data for a town
    /// - Parameter town: The town to analyze
    /// - Returns: Category completion data
    func getCategoryCompletionData(town: Town) throws -> CategoryCompletionData {
        let cacheKey = "\(town.id)_completion"
        
        // Check cache first
        if isCacheValid(), let cachedData = cachedCompletionData[cacheKey] {
            return cachedData
        }
        
        do {
            let fossilProgress = try donationService.getFossilProgressForTown(town: town)
            let bugProgress = try donationService.getBugProgressForTown(town: town)
            let fishProgress = try donationService.getFishProgressForTown(town: town)
            let artProgress = try donationService.getArtProgressForTown(town: town)
            let fossils = try donationService.getFossilsForTown(town: town)
            let bugs = try donationService.getBugsForTown(town: town)
            let fish = try donationService.getFishForTown(town: town)
            let artPieces = try donationService.getArtForTown(town: town)
            let totalProgress = try donationService.getTotalProgressForTown(town: town)
            let result = CategoryCompletionData(
                fossilCount: fossils.count,
                fossilDonated: fossils.filter { $0.isDonated }.count,
                fossilProgress: fossilProgress,
                bugCount: bugs.count,
                bugDonated: bugs.filter { $0.isDonated }.count,
                bugProgress: bugProgress,
                fishCount: fish.count,
                fishDonated: fish.filter { $0.isDonated }.count,
                fishProgress: fishProgress,
                artCount: artPieces.count,
                artDonated: artPieces.filter { $0.isDonated }.count,
                artProgress: artProgress,
                totalProgress: totalProgress
            )
            cachedCompletionData[cacheKey] = result
            lastCacheTime = Date()
            return result
        } catch let error as ServiceError {
            throw ServiceError.analyticsProcessingFailed(operationType: "getCategoryCompletionData", reason: "Service error", underlyingError: error)
        } catch {
            throw ServiceError.analyticsProcessingFailed(operationType: "getCategoryCompletionData", reason: "Unknown error", underlyingError: error)
        }
    }
    
    // MARK: - Seasonal Analysis
    
    /// Get seasonal data for bugs and fish
    /// - Parameter town: The town to analyze
    /// - Returns: Seasonal data
    func getSeasonalData(town: Town) throws -> SeasonalData {
        let cacheKey = "\(town.id)_seasonal"
        
        // Check cache first
        if isCacheValid(), let cachedData = cachedSeasonalData[cacheKey] {
            return cachedData
        }
        
        do {
            let bugs = try donationService.getBugsForTown(town: town)
            let fish = try donationService.getFishForTown(town: town)
            
            var seasonalBugs: [String: [Bug]] = [:]
            var seasonalFish: [String: [Fish]] = [:]
            
            // Initialize all months to ensure we have complete data
            let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            for month in monthAbbreviations {
                seasonalBugs[month] = []
                seasonalFish[month] = []
            }
            
            // Map bugs to seasons
            for bug in bugs {
                if let season = bug.season {
                    let seasons = parseSeasons(season)
                    for s in seasons {
                        if seasonalBugs[s] != nil {
                            seasonalBugs[s]!.append(bug)
                        } else {
                            seasonalBugs[s] = [bug]
                        }
                    }
                }
            }
            
            // Map fish to seasons
            for fish in fish {
                let seasons = parseSeasons(fish.season)
                for s in seasons {
                    if seasonalFish[s] != nil {
                        seasonalFish[s]!.append(fish)
                    } else {
                        seasonalFish[s] = [fish]
                    }
                }
            }
            
            // Calculate completion rates by season
            var seasonalCompletion: [String: SeasonalCompletion] = [:]
            
            for (season, bugs) in seasonalBugs {
                let totalBugs = bugs.count
                let donatedBugs = bugs.filter { $0.isDonated }.count
                let bugProgress = totalBugs > 0 ? Double(donatedBugs) / Double(totalBugs) : 0.0
                
                if seasonalCompletion[season] != nil {
                    seasonalCompletion[season]!.bugCount = totalBugs
                    seasonalCompletion[season]!.bugDonated = donatedBugs
                    seasonalCompletion[season]!.bugProgress = bugProgress
                } else {
                    seasonalCompletion[season] = SeasonalCompletion(
                        season: season,
                        bugCount: totalBugs,
                        bugDonated: donatedBugs,
                        bugProgress: bugProgress,
                        fishCount: 0,
                        fishDonated: 0,
                        fishProgress: 0.0
                    )
                }
            }
            
            for (season, fishArray) in seasonalFish {
                let totalFish = fishArray.count
                let donatedFish = fishArray.filter { $0.isDonated }.count
                let fishProgress = totalFish > 0 ? Double(donatedFish) / Double(totalFish) : 0.0
                
                if seasonalCompletion[season] != nil {
                    seasonalCompletion[season]!.fishCount = totalFish
                    seasonalCompletion[season]!.fishDonated = donatedFish
                    seasonalCompletion[season]!.fishProgress = fishProgress
                } else {
                    seasonalCompletion[season] = SeasonalCompletion(
                        season: season,
                        bugCount: 0,
                        bugDonated: 0,
                        bugProgress: 0.0,
                        fishCount: totalFish,
                        fishDonated: donatedFish,
                        fishProgress: fishProgress
                    )
                }
            }
            
            // Convert seasonalCompletion to array, sorted by month
            let monthOrder = Dictionary(uniqueKeysWithValues: monthAbbreviations.enumerated().map { ($1, $0) })
            let seasonalCompletionArray = seasonalCompletion.values.sorted { 
                let order1 = monthOrder[$0.season] ?? 0
                let order2 = monthOrder[$1.season] ?? 0
                return order1 < order2
            }
            
            let result = SeasonalData(seasonalCompletion: seasonalCompletionArray)
            
            // Cache the result
            cachedSeasonalData[cacheKey] = result
            lastCacheTime = Date()
            
            return result
        } catch let error as ServiceError {
            throw ServiceError.analyticsProcessingFailed(operationType: "getSeasonalData", reason: "Service error", underlyingError: error)
        } catch {
            throw ServiceError.analyticsProcessingFailed(operationType: "getSeasonalData", reason: "Unknown error", underlyingError: error)
        }
    }
    
    // Helper method to parse season strings into individual months
    private func parseSeasons(_ seasonString: String) -> [String] {
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var months: [String] = []
        
        // Common formats: "March - June", "January - March, October", etc.
        let components = seasonString.components(separatedBy: ",")
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            
            if trimmed.contains("-") || trimmed.contains(" - ") {
                // Handle ranges like "March - June"
                let rangeParts = trimmed.components(separatedBy: " - ").map { $0.trimmingCharacters(in: .whitespaces) }
                
                if rangeParts.count == 2, 
                   let startIdx = monthAbbreviations.firstIndex(where: { rangeParts[0].hasPrefix($0) }),
                   let endIdx = monthAbbreviations.firstIndex(where: { rangeParts[1].hasPrefix($0) }) {
                    
                    if startIdx <= endIdx {
                        // Normal range: "Mar - Jul"
                        for i in startIdx...endIdx {
                            months.append(monthAbbreviations[i])
                        }
                    } else {
                        // Wrapping range: "Oct - Feb"
                        for i in startIdx..<monthAbbreviations.count {
                            months.append(monthAbbreviations[i])
                        }
                        for i in 0...endIdx {
                            months.append(monthAbbreviations[i])
                        }
                    }
                }
            } else {
                // Handle single months like "January"
                if let idx = monthAbbreviations.firstIndex(where: { trimmed.hasPrefix($0) }) {
                    months.append(monthAbbreviations[idx])
                }
            }
        }
        
        // If no months were found, return all months (available all year)
        if months.isEmpty {
            return monthAbbreviations
        }
        
        return months
    }
}

// MARK: - Analytics Data Models

/// Categories for donations
enum DonationCategory {
    case fossil, bug, fish, art
}

/// Monthly donation activity data
struct MonthlyDonationActivity: Identifiable {
    var id: String { month.formatted(.dateTime.year().month()) }
    var month: Date
    var fossilCount: Int
    var bugCount: Int
    var fishCount: Int
    var artCount: Int
    var totalCount: Int = 0
    
    var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
}

/// Category completion data
struct CategoryCompletionData {
    var fossilCount: Int
    var fossilDonated: Int
    var fossilProgress: Double
    
    var bugCount: Int
    var bugDonated: Int
    var bugProgress: Double
    
    var fishCount: Int
    var fishDonated: Int
    var fishProgress: Double
    
    var artCount: Int
    var artDonated: Int
    var artProgress: Double
    
    var totalProgress: Double
    
    var totalCount: Int {
        return fossilCount + bugCount + fishCount + artCount
    }
    
    var totalDonated: Int {
        return fossilDonated + bugDonated + fishDonated + artDonated
    }
}

/// Seasonal completion data
struct SeasonalCompletion: Identifiable {
    var id: String { season }
    var season: String
    var bugCount: Int
    var bugDonated: Int
    var bugProgress: Double
    var fishCount: Int
    var fishDonated: Int
    var fishProgress: Double
    
    var totalCount: Int {
        return bugCount + fishCount
    }
    
    var totalDonated: Int {
        return bugDonated + fishDonated
    }
    
    var totalProgress: Double {
        if totalCount == 0 { return 0.0 }
        return Double(totalDonated) / Double(totalCount)
    }
}

/// Overall seasonal data
struct SeasonalData {
    var seasonalCompletion: [SeasonalCompletion]
    
    func currentSeasonCompletion() -> SeasonalCompletion? {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let currentMonthAbbr = monthAbbreviations[currentMonth - 1]
        
        return seasonalCompletion.first { $0.season == currentMonthAbbr }
    }
}
