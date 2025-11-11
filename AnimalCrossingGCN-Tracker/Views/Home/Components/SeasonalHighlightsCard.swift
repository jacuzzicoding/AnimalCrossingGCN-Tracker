//
//  SeasonalHighlightsCard.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

/// Card showing seasonal highlights
struct SeasonalHighlightsCard: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Seasonal Highlights")
                    .font(.headline)
                    .foregroundColor(.black)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if let seasonalItems = getCurrentSeasonalItems() {
                        ForEach(seasonalItems) { item in
                            SeasonalItemView(
                                title: item.name,
                                description: item.description,
                                color: item.isLeaving ? .acPumpkinOrange : .acLeafGreen
                            )
                        }
                    } else {
                        Text("No seasonal items available")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }

    // Real implementation to get current seasonal items
    private func getCurrentSeasonalItems() -> [SeasonalItem]? {
        // Get current month
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())

        // Get current season abbreviation
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let currentMonthAbbr = monthAbbreviations[currentMonth - 1]

        // Get bugs from current town
        var availableBugs: [Bug] = []
        let bugs: [Bug] = {
            do {
                return try dataManager.getBugsForCurrentTown()
            } catch {
                print("Error fetching bugs for current town: \(error)")
                return []
            }
        }()
        for bug in bugs {
            if let season = bug.season, season.contains(currentMonthAbbr) {
                availableBugs.append(bug)
            }
        }

        // Get fish from current town
        var availableFish: [Fish] = []
        let fish: [Fish] = {
            do {
                return try dataManager.getFishForCurrentTown()
            } catch {
                print("Error fetching fish for current town: \(error)")
                return []
            }
        }()
        for fish in fish {
            if fish.season.contains(currentMonthAbbr) {
                availableFish.append(fish)
            }
        }

        // Create seasonal items
        var seasonalItems: [SeasonalItem] = []

        // Add up to 3 bugs
        for bug in availableBugs.prefix(2) {
            let isLeaving = isLeavingSoon(season: bug.season ?? "", currentMonth: currentMonthAbbr)
            let description = isLeaving ? "Leaving soon!" : "Available now!"
            seasonalItems.append(SeasonalItem(id: bug.id.uuidString, name: bug.name, description: description, isLeaving: isLeaving))
        }

        // Add up to 3 fish
        for fish in availableFish.prefix(2) {
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

    // Helper to determine if an item is leaving soon
    private func isLeavingSoon(season: String, currentMonth: String) -> Bool {
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        guard let currentIndex = monthAbbreviations.firstIndex(of: currentMonth) else {
            return false
        }

        // Check if item is available in current month but not in next month
        let nextMonthIndex = (currentIndex + 1) % 12
        let nextMonth = monthAbbreviations[nextMonthIndex]

        return season.contains(currentMonth) && !season.contains(nextMonth)
    }
}

// Seasonal item model
struct SeasonalItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let isLeaving: Bool
}

/// Individual seasonal item component
struct SeasonalItemView: View {
    let title: String
    let description: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text(description)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .frame(width: 140, height: 80)
        .background(Color.white.opacity(0.8))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
}
