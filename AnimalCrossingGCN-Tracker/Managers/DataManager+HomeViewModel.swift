//
//  DataManager+HomeViewModel.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/6/25.
//

import Foundation
import SwiftUI

/// Extension of DataManager to implement the DataManaging protocol for HomeViewModel
extension DataManager: DataManaging {
    
    /// Fetches the overall collection status data for the current town
    /// - Returns: Collection status data, or throws an error if no town is selected
    func fetchCollectionStatus() async throws -> CollectionStatusData {
        guard let town = currentTown else {
            throw DataManagerError.noCurrentTown
        }

        // Simulating network latency for testing
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Get completion data from analytics service
        let completion = getCategoryCompletionData()
        
        // If we have completion data, create a CollectionStatusData object
        if let completion = completion {
            return CollectionStatusData(
                totalCollected: completion.totalDonated,
                totalAvailable: completion.totalCount,
                completionPercentage: completion.totalProgress
            )
        } else {
            throw DataManagerError.dataNotAvailable
        }
    }
    
    /// Fetches category progress data for each museum category
    /// - Returns: Array of category progress data, or throws an error if no town is selected
    func fetchCategoryProgress() async throws -> [CategoryProgressData] {
        guard let town = currentTown else {
            throw DataManagerError.noCurrentTown
        }
        
        // Simulating network latency for testing
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Get completion data from analytics service
        guard let completion = getCategoryCompletionData() else {
            throw DataManagerError.dataNotAvailable
        }
        
        // Create CategoryProgressData objects for each museum category
        var progressData: [CategoryProgressData] = []
        
        // Fossils
        progressData.append(CategoryProgressData(
            category: .fossils,
            name: "FOSSILS",
            icon: "leaf.arrow.circlepath",
            color: .acMuseumBrown,
            collected: completion.fossilDonated,
            total: completion.fossilCount,
            progress: completion.fossilProgress
        ))
        
        // Bugs
        progressData.append(CategoryProgressData(
            category: .bugs,
            name: "BUGS",
            icon: "ant.fill",
            color: .green,
            collected: completion.bugDonated,
            total: completion.bugCount,
            progress: completion.bugProgress
        ))
        
        // Fish
        progressData.append(CategoryProgressData(
            category: .fish,
            name: "FISH",
            icon: "fish.fill",
            color: .acOceanBlue,
            collected: completion.fishDonated,
            total: completion.fishCount,
            progress: completion.fishProgress
        ))
        
        // Art
        progressData.append(CategoryProgressData(
            category: .art,
            name: "ART",
            icon: "paintpalette.fill",
            color: .acBlathersPurple,
            collected: completion.artDonated,
            total: completion.artCount,
            progress: completion.artProgress
        ))
        
        return progressData
    }
    
    /// Fetches seasonal highlights data for the current month
    /// - Returns: Array of seasonal items, or throws an error if no town is selected
    func fetchSeasonalHighlights() async throws -> [SeasonalItem] {
        guard let town = currentTown else {
            throw DataManagerError.noCurrentTown
        }
        
        // Simulating network latency for testing
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Get current month
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        
        // Get current season abbreviation
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let currentMonthAbbr = monthAbbreviations[currentMonth - 1]
        
        // Get bugs from current town
        var availableBugs: [Bug] = []
        for bug in getBugsForCurrentTown() {
            if let season = bug.season, season.contains(currentMonthAbbr) {
                availableBugs.append(bug)
            }
        }
        
        // Get fish from current town
        var availableFish: [Fish] = []
        for fish in getFishForCurrentTown() {
            if fish.season.contains(currentMonthAbbr) {
                availableFish.append(fish)
            }
        }
        
        // Create seasonal items
        var seasonalItems: [SeasonalItem] = []
        
        // Function to determine if an item is leaving soon
        func isLeavingSoon(season: String, currentMonth: String) -> Bool {
            guard let currentIndex = monthAbbreviations.firstIndex(of: currentMonth) else {
                return false
            }
            
            // Check if item is available in current month but not in next month
            let nextMonthIndex = (currentIndex + 1) % 12
            let nextMonth = monthAbbreviations[nextMonthIndex]
            
            return season.contains(currentMonth) && !season.contains(nextMonth)
        }
        
        // Add up to 3 bugs
        for bug in availableBugs.prefix(3) {
            let isLeaving = isLeavingSoon(season: bug.season ?? "", currentMonth: currentMonthAbbr)
            let description = isLeaving ? "Leaving soon!" : "Available now!"
            seasonalItems.append(SeasonalItem(id: bug.id.uuidString, name: bug.name, description: description, isLeaving: isLeaving))
        }
        
        // Add up to 3 fish
        for fish in availableFish.prefix(3) {
            let isLeaving = isLeavingSoon(season: fish.season, currentMonth: currentMonthAbbr)
            let description = isLeaving ? "Leaving soon!" : "Available now!"
            seasonalItems.append(SeasonalItem(id: fish.id.uuidString, name: fish.name, description: description, isLeaving: isLeaving))
        }
        
        // If we don't have enough seasonal items, add placeholders
        if seasonalItems.isEmpty {
            // Fallback to placeholder data
            seasonalItems = [
                SeasonalItem(id: "1", name: "Common Butterfly", description: "Available Now!", isLeaving: false),
                SeasonalItem(id: "2", name: "Mole Cricket", description: "Leaving soon!", isLeaving: true),
                SeasonalItem(id: "3", name: "Emperor Butterfly", description: "Coming next month!", isLeaving: false)
            ]
        }
        
        return seasonalItems
    }
    
    /// Fetches recent donations for display on the home screen
    /// - Returns: Array of recent donation items, or throws an error if no town is selected
    func fetchRecentDonations() async throws -> [DonationItem] {
        guard let town = currentTown else {
            throw DataManagerError.noCurrentTown
        }
        
        // Simulating network latency for testing
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Get all donated items with timestamp
        var donatedItems: [(name: String, date: Date, color: Color)] = []
        
        // Add fossils
        for fossil in getFossilsForCurrentTown().filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fossil.donationDate {
                let name = fossil.part != nil ? "\(fossil.name) \(fossil.part!)" : fossil.name
                donatedItems.append((name: name, date: date, color: .acMuseumBrown))
            }
        }
        
        // Add bugs
        for bug in getBugsForCurrentTown().filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = bug.donationDate {
                donatedItems.append((name: bug.name, date: date, color: .green))
            }
        }
        
        // Add fish
        for fish in getFishForCurrentTown().filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fish.donationDate {
                donatedItems.append((name: fish.name, date: date, color: .acOceanBlue))
            }
        }
        
        // Add art
        for art in getArtForCurrentTown().filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = art.donationDate {
                donatedItems.append((name: art.name, date: date, color: .acBlathersPurple))
            }
        }
        
        // Sort by date (most recent first)
        donatedItems.sort { $0.date > $1.date }
        
        // Helper to format relative time
        func relativeTimeString(from date: Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)
            
            if let day = components.day, day > 0 {
                return day == 1 ? "Yesterday" : "\(day) days ago"
            } else if let hour = components.hour, hour > 0 {
                return "\(hour) hour\(hour == 1 ? "" : "s") ago"
            } else if let minute = components.minute, minute > 0 {
                return "\(minute) minute\(minute == 1 ? "" : "s") ago"
            } else {
                return "Just now"
            }
        }
        
        // Convert to DonationItem objects with relative time
        let recentDonations = donatedItems.prefix(5).map { item in
            DonationItem(
                title: item.name,
                time: relativeTimeString(from: item.date),
                color: item.color
            )
        }
        
        return Array(recentDonations)
    }
}
