//
//  DonationTrackingViewModel.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 12/18/24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

@MainActor
class DonationTrackingViewModel: ObservableObject {
    // Dependencies
    private let modelContext: ModelContext
    
    // Published properties for UI updates
    @Published var monthlyDonationCounts: [MonthlyDonationCount] = []
    @Published var totalDonations: Int = 0
    @Published var recentDonations: [AnyCollectibleItem] = []
    @Published var selectedDateRange: DateRange = .allTime
    @Published var selectedGame: ACGame?
    @Published var selectedCategories: Set<ItemCategory> = Set(ItemCategory.allCases)
    
    // Date-related properties
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
    @Published var endDate: Date = Date()
    
    // MARK: - Initialization
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadDonationData()
        }
    }
    
    // MARK: - Public Methods
    
    func loadDonationData() async {
        await loadMonthlyDonationCounts()
        await loadTotalDonations()
        await loadRecentDonations()
    }
    
    func applyFilters() async {
        await loadDonationData()
    }
    
    func resetFilters() {
        selectedDateRange = .allTime
        selectedGame = nil
        selectedCategories = Set(ItemCategory.allCases)
        startDate = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        endDate = Date()
        
        Task {
            await loadDonationData()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMonthlyDonationCounts() async {
        var allItems: [AnyCollectibleItem] = []
        
        // Load fossils
        let fossilDescriptor = FetchDescriptor<Fossil>(predicate: buildPredicate(for: Fossil.self))
        if let fossils = try? modelContext.fetch(fossilDescriptor) {
            allItems.append(contentsOf: fossils.map { AnyCollectibleItem($0) })
        }
        
        // Load bugs
        let bugDescriptor = FetchDescriptor<Bug>(predicate: buildPredicate(for: Bug.self))
        if let bugs = try? modelContext.fetch(bugDescriptor) {
            allItems.append(contentsOf: bugs.map { AnyCollectibleItem($0) })
        }
        
        // Load fish
        let fishDescriptor = FetchDescriptor<Fish>(predicate: buildPredicate(for: Fish.self))
        if let fish = try? modelContext.fetch(fishDescriptor) {
            allItems.append(contentsOf: fish.map { AnyCollectibleItem($0) })
        }
        
        // Load art
        let artDescriptor = FetchDescriptor<Art>(predicate: buildPredicate(for: Art.self))
        if let art = try? modelContext.fetch(artDescriptor) {
            allItems.append(contentsOf: art.map { AnyCollectibleItem($0) })
        }
        
        // Filter items based on donation status and dates
        let donatedItems = allItems.filter { item in
            item.isDonated && item.donationDate != nil &&
            (dateRangeContains(item.donationDate!) || selectedDateRange == .allTime)
        }
        
        // Group by month and year
        let groupedByMonth = Dictionary(grouping: donatedItems) { item -> String in
            guard let date = item.donationDate else { return "Unknown" }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.string(from: date)
        }
        
        // Convert to monthly counts and sort
        monthlyDonationCounts = groupedByMonth.map { (key, items) in
            let parts = key.split(separator: "-")
            let year = Int(parts[0]) ?? 0
            let month = Int(parts[1]) ?? 1
            
            let dateComponents = DateComponents(year: year, month: month)
            let date = Calendar.current.date(from: dateComponents) ?? Date()
            
            return MonthlyDonationCount(
                date: date,
                count: items.count,
                fossilCount: items.filter { $0.category == .fossils }.count,
                bugCount: items.filter { $0.category == .bugs }.count,
                fishCount: items.filter { $0.category == .fish }.count,
                artCount: items.filter { $0.category == .art }.count,
                seaCreatureCount: items.filter { $0.category == .seaCreatures }.count
            )
        }.sorted { $0.date < $1.date }
    }
    
    private func loadTotalDonations() async {
        let allCategories = selectedCategories.map { $0 }
        
        totalDonations = 0
        
        for category in allCategories {
            switch category {
            case .fossils:
                let descriptor = FetchDescriptor<Fossil>(predicate: buildPredicate(for: Fossil.self))
                if let fossils = try? modelContext.fetch(descriptor) {
                    totalDonations += fossils.filter { 
                        $0.isDonated && 
                        ($0.donationDate == nil || dateRangeContains($0.donationDate!) || selectedDateRange == .allTime)
                    }.count
                }
            case .bugs:
                let descriptor = FetchDescriptor<Bug>(predicate: buildPredicate(for: Bug.self))
                if let bugs = try? modelContext.fetch(descriptor) {
                    totalDonations += bugs.filter { 
                        $0.isDonated && 
                        ($0.donationDate == nil || dateRangeContains($0.donationDate!) || selectedDateRange == .allTime)
                    }.count
                }
            case .fish:
                let descriptor = FetchDescriptor<Fish>(predicate: buildPredicate(for: Fish.self))
                if let fish = try? modelContext.fetch(descriptor) {
                    totalDonations += fish.filter { 
                        $0.isDonated && 
                        ($0.donationDate == nil || dateRangeContains($0.donationDate!) || selectedDateRange == .allTime)
                    }.count
                }
            case .art:
                let descriptor = FetchDescriptor<Art>(predicate: buildPredicate(for: Art.self))
                if let art = try? modelContext.fetch(descriptor) {
                    totalDonations += art.filter { 
                        $0.isDonated && 
                        ($0.donationDate == nil || dateRangeContains($0.donationDate!) || selectedDateRange == .allTime)
                    }.count
                }
            case .seaCreatures:
                // Assuming there's a SeaCreature model
                // let descriptor = FetchDescriptor<SeaCreature>(predicate: buildPredicate(for: .seaCreatures))
                // if let seaCreatures = try? modelContext.fetch(descriptor) {
                //    totalDonations += seaCreatures.filter { 
                //        $0.isDonated && 
                //        ($0.donationDate == nil || dateRangeContains($0.donationDate!) || selectedDateRange == .allTime)
                //    }.count
                // }
                break
            }
        }
    }
    
    private func loadRecentDonations() async {
        var allItems: [AnyCollectibleItem] = []
        
        // Load fossils if category is selected
        if selectedCategories.contains(.fossils) {
            let fossilDescriptor = FetchDescriptor<Fossil>(predicate: buildPredicate(for: Fossil.self))
            if let fossils = try? modelContext.fetch(fossilDescriptor) {
                allItems.append(contentsOf: fossils.map { AnyCollectibleItem($0) })
            }
        }
        
        // Load bugs if category is selected
        if selectedCategories.contains(.bugs) {
            let bugDescriptor = FetchDescriptor<Bug>(predicate: buildPredicate(for: Bug.self))
            if let bugs = try? modelContext.fetch(bugDescriptor) {
                allItems.append(contentsOf: bugs.map { AnyCollectibleItem($0) })
            }
        }
        
        // Load fish if category is selected
        if selectedCategories.contains(.fish) {
            let fishDescriptor = FetchDescriptor<Fish>(predicate: buildPredicate(for: Fish.self))
            if let fish = try? modelContext.fetch(fishDescriptor) {
                allItems.append(contentsOf: fish.map { AnyCollectibleItem($0) })
            }
        }
        
        // Load art if category is selected
        if selectedCategories.contains(.art) {
            let artDescriptor = FetchDescriptor<Art>(predicate: buildPredicate(for: Art.self))
            if let art = try? modelContext.fetch(artDescriptor) {
                allItems.append(contentsOf: art.map { AnyCollectibleItem($0) })
            }
        }
        
        // Filter and sort items
        recentDonations = allItems
            .filter { item in
                item.isDonated && item.donationDate != nil &&
                (dateRangeContains(item.donationDate!) || selectedDateRange == .allTime)
            }
            .sorted { ($0.donationDate ?? Date.distantPast) > ($1.donationDate ?? Date.distantPast) }
            .prefix(10)
            .map { $0 }
    }
    
    // Generic function to build predicate for a specific type
    private func buildPredicate<T: CollectibleItem>(for type: T.Type) -> Predicate<T> {
        // If no game is selected, return a predicate that matches everything
        guard let selectedGame = selectedGame else {
            return #Predicate<T> { _ in true }
        }
        
        // Create a game filter predicate
        return #Predicate<T> { item in
            item.games.contains { $0.rawValue == selectedGame.rawValue }
        }
        
        // Date range filter will be applied after fetching since donationDate might be nil
    }
    
    private func dateRangeContains(_ date: Date) -> Bool {
        switch selectedDateRange {
        case .custom:
            return date >= startDate && date <= endDate
        case .lastWeek:
            let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return date >= lastWeek && date <= Date()
        case .lastMonth:
            let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            return date >= lastMonth && date <= Date()
        case .lastYear:
            let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            return date >= lastYear && date <= Date()
        case .allTime:
            return true
        }
    }
}

// MARK: - Supporting Types

// Date range options for filtering
enum DateRange: String, CaseIterable, Identifiable {
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    case lastYear = "Last Year"
    case custom = "Custom Range"
    case allTime = "All Time"
    
    var id: String { self.rawValue }
}

// Monthly donation count for charts
struct MonthlyDonationCount: Identifiable {
    var id = UUID()
    var date: Date
    var count: Int
    var fossilCount: Int
    var bugCount: Int
    var fishCount: Int
    var artCount: Int
    var seaCreatureCount: Int
    
    var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

// Category enum for filtering
enum ItemCategory: String, CaseIterable, Identifiable {
    case fossils = "Fossils"
    case bugs = "Bugs"
    case fish = "Fish"
    case art = "Art"
    case seaCreatures = "Sea Creatures"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .fossils: return "fossil.shell.fill"
        case .bugs: return "ant.fill"
        case .fish: return "fish.fill"
        case .art: return "paintpalette.fill"
        case .seaCreatures: return "water.waves"
        }
    }
    
    var color: Color {
        switch self {
        case .fossils: return .brown
        case .bugs: return .green
        case .fish: return .blue
        case .art: return .purple
        case .seaCreatures: return .teal
        }
    }
}

// Type-erased wrapper for CollectibleItem to handle different item types uniformly
struct AnyCollectibleItem: Identifiable, Hashable {
    private let _base: any CollectibleItem
    
    var id: UUID { _base.id }
    var name: String { _base.name }
    var isDonated: Bool { _base.isDonated }
    var donationDate: Date? { _base.donationDate }
    var games: [ACGame] { _base.games }
    
    var category: ItemCategory {
        switch _base {
        case is Fossil: return .fossils
        case is Bug: return .bugs
        case is Fish: return .fish
        case is Art: return .art
        // case is SeaCreature: return .seaCreatures
        default: fatalError("Unknown item type")
        }
    }
    
    init(_ base: some CollectibleItem) {
        self._base = base
    }
    
    // Identifiable and Hashable conformance
    static func == (lhs: AnyCollectibleItem, rhs: AnyCollectibleItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
