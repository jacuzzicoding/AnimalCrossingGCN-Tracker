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
    
    // MARK: - Timeline Analytics
    
    /// Get donation activity by month for a specific town
    /// - Parameters:
    ///   - town: The town to analyze
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
    /// - Returns: Array of monthly donation activity data
    func getDonationActivityByMonth(town: Town, startDate: Date? = nil, endDate: Date? = nil) -> [MonthlyDonationActivity] {
        let fossils = donationService.getFossilsForTown(town: town).filter { $0.isDonated && $0.donationDate != nil }
        let bugs = donationService.getBugsForTown(town: town).filter { $0.isDonated && $0.donationDate != nil }
        let fish = donationService.getFishForTown(town: town).filter { $0.isDonated && $0.donationDate != nil }
        let artPieces = donationService.getArtForTown(town: town).filter { $0.isDonated && $0.donationDate != nil }
        
        // Group by month
        var monthlyActivity: [String: MonthlyDonationActivity] = [:]
        
        // Process each donation type
        processMonthlyDonations(fossils, category: .fossil, into: &monthlyActivity, startDate: startDate, endDate: endDate)
        processMonthlyDonations(bugs, category: .bug, into: &monthlyActivity, startDate: startDate, endDate: endDate)
        processMonthlyDonations(fish, category: .fish, into: &monthlyActivity, startDate: startDate, endDate: endDate)
        processMonthlyDonations(artPieces, category: .art, into: &monthlyActivity, startDate: startDate, endDate: endDate)
        
        // Convert to array and sort by date
        return monthlyActivity.values.sorted { $0.month < $1.month }
    }
    
    /// Process donations into monthly activity
    /// - Parameters:
    ///   - items: The items to process
    ///   - category: The category of the items
    ///   - monthlyActivity: The dictionary to store results in
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
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
        
        for item in items {
            guard let donationDate = item.donationDate else { continue }
            
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
    
    // MARK: - Category Analysis
    
    /// Get category completion data for a town
    /// - Parameter town: The town to analyze
    /// - Returns: Category completion data
    func getCategoryCompletionData(town: Town) -> CategoryCompletionData {
        let fossilProgress = donationService.getFossilProgressForTown(town: town)
        let bugProgress = donationService.getBugProgressForTown(town: town)
        let fishProgress = donationService.getFishProgressForTown(town: town)
        let artProgress = donationService.getArtProgressForTown(town: town)
        
        let fossils = donationService.getFossilsForTown(town: town)
        let bugs = donationService.getBugsForTown(town: town)
        let fish = donationService.getFishForTown(town: town)
        let artPieces = donationService.getArtForTown(town: town)
        
        return CategoryCompletionData(
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
            totalProgress: donationService.getTotalProgressForTown(town: town)
        )
    }
    
    // MARK: - Seasonal Analysis
    
    /// Get seasonal data for bugs and fish
    /// - Parameter town: The town to analyze
    /// - Returns: Seasonal data
    func getSeasonalData(town: Town) -> SeasonalData {
        let bugs = donationService.getBugsForTown(town: town)
        let fish = donationService.getFishForTown(town: town)
        
        var seasonalBugs: [String: [Bug]] = [:]
        var seasonalFish: [String: [Fish]] = [:]
        
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
        
        return SeasonalData(
            seasonalCompletion: seasonalCompletion.values.sorted { $0.season < $1.season }
        )
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
