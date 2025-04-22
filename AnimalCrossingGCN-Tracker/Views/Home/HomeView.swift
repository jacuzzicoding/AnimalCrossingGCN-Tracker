//
//  HomeView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//  Updated on 2/27/25.
//
//  This file implements the home screen for the Animal Crossing GCN Tracker app.
//  It provides an overview of the user's museum collection status and quick access
//  to key functionality. The interface adapts for both light and dark mode.

import SwiftUI
import SwiftData

#if canImport(UIKit)
import UIKit
#endif

/// Main home screen view for the Animal Crossing GCN Tracker app
struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @State private var isEditingTown: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with town info
                HomeHeaderView(isEditingTown: $isEditingTown)
                    .padding(.bottom, 4)
                
                // Collection status card
                CollectionStatusCard()
                
                // Category grid
                CategoryGridView()
                    .padding(.vertical, 8)
                
                // Seasonal highlights
                SeasonalHighlightsCard()
                
                // Recent donations
                RecentDonationsCard()
                
                // Spacer for bottom tab bar
                Spacer().frame(height: 20)
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .background(Color(hex: "F9F5E9")) // Parchment background
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditingTown) {
            if let town = dataManager.currentTown {
                EditTownView(isPresented: $isEditingTown, townName: .constant(town.name))
                    .environmentObject(dataManager)
            }
        }
    }
}

/// Header view with town information and settings
struct HomeHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isEditingTown: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dataManager.currentTown?.name ?? "My Town")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("Mayor: \(dataManager.currentTown?.playerName ?? "Player")")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    isEditingTown = true
                }) {
                    Text("Edit")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.acLeafGreen)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
                Button(action: {
                    // Settings action
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.acLeafGreen)
                }
            }
        }
        .padding()
        .background(Color.acLeafGreen.opacity(0.2))
        .cornerRadius(10)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}

/// Card showing overall collection status
struct CollectionStatusCard: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "building.columns.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Museum Collection Status")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .opacity(0.2)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(dataManager.getCurrentTownProgress()) * geometry.size.width, geometry.size.width), height: 20)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: dataManager.getCurrentTownProgress())
                    
                    HStack {
                        Spacer()
                        Text("\(Int(dataManager.getCurrentTownProgress() * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 20)
            
            // Total count
            HStack {                
                let completion: CategoryCompletionData? = {
                    do {
                        return try dataManager.getCategoryCompletionData()
                    } catch {
                        print("Error fetching category completion data: \(error)")
                        return nil
                    }
                }()
                if let completion = completion {
                    Text("\(completion.totalDonated) of \(completion.totalCount) Items Donated")
                        .font(.subheadline)
                        .foregroundColor(.black)
                } else {
                    Text("0 of 0 Items Donated")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .accessibilityElement(children: .combine)
            .accessibilityLabel("Museum Collection Status: \(Int(dataManager.getCurrentTownProgress() * 100))% complete")
}
}

/// Grid of category cards with completion status
struct CategoryGridView: View {
	@EnvironmentObject var dataManager: DataManager
	@EnvironmentObject var categoryManager: CategoryManager
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "square.grid.2x2.fill")
					.foregroundColor(.acLeafGreen)
					.font(.headline)
				Text("Museum Categories")
					.font(.headline)
					.foregroundColor(.black)
			}
			.padding(.bottom, 6)
			
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible())
			], spacing: 16) {
				// Fossils card
				CategoryCard(
					title: "FOSSILS",
					icon: "leaf.arrow.circlepath",
					progress: dataManager.getCurrentTownFossilProgress(),
					color: .acMuseumBrown,
					emoji: "🦴",
					category: .fossils
				)
				
				// Bugs card
				CategoryCard(
					title: "BUGS",
					icon: "ant.fill",
					progress: dataManager.getCurrentTownBugProgress(),
					color: .green,
					emoji: "🐛",
					category: .bugs
				)
				
				// Fish card
				CategoryCard(
					title: "FISH",
					icon: "fish.fill",
					progress: dataManager.getCurrentTownFishProgress(),
					color: .acOceanBlue,
					emoji: "🐟",
					category: .fish
				)
				
				// Art card
				CategoryCard(
					title: "ART",
					icon: "paintpalette.fill",
					progress: dataManager.getCurrentTownArtProgress(),
					color: .acBlathersPurple,
					emoji: "🎨",
					category: .art
				)
			}
		}
	}
	
	/// Individual category card component
	struct CategoryCard: View {
		@EnvironmentObject var categoryManager: CategoryManager
		@EnvironmentObject var dataManager: DataManager
		
		let title: String
		let icon: String
		let progress: Double
		let color: Color
		let emoji: String
		let category: Category
		
		// Computed property for donation info
		private var donationInfo: String? {
            do {
                guard let completion = try dataManager.getCategoryCompletionData() else { return nil }
                let donated: Int
                let total: Int
                
                switch category {
                case .fossils:
                    donated = completion.fossilDonated
                    total = completion.fossilCount
                case .bugs:
                    donated = completion.bugDonated
                    total = completion.bugCount
                case .fish:
                    donated = completion.fishDonated
                    total = completion.fishCount
                case .art:
                    donated = completion.artDonated
                    total = completion.artCount
                }
                
                return "\(donated)/\(total)"
            } catch {
                print("Error fetching category completion data in CategoryCard: \(error)")
                return nil
            }
        }
		
		var body: some View {
			Button(action: {
				// Handle category selection and navigation
				categoryManager.selectedItem = nil
				categoryManager.selectedCategory = category
				categoryManager.showingAnalytics = false
			}) {
				VStack(spacing: 12) {
					HStack {
						Image(systemName: category.symbolName)
							.font(.system(size: 18))
							.foregroundColor(.white)
						
						Text(title)
							.font(.headline)
							.foregroundColor(.white)
						
						Spacer()
					}
					
					Spacer()
					
					ZStack {
						Circle()
							.fill(Color.white.opacity(0.2))
							.frame(width: 60, height: 60)
						
						VStack(spacing: 4) {
							Text("\(Int(progress * 100))%")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.white)
							
							if let info = donationInfo {
								Text(info)
									.font(.caption)
									.foregroundColor(.white.opacity(0.9))
							}
						}
					}
					
					Spacer()
					
					Spacer()
					
					HStack {
						Spacer()
						
						HStack {
							Text("View All")
								.font(.caption)
								.fontWeight(.semibold)
								.foregroundColor(.white)
							
							Image(systemName: "chevron.right")
								.font(.caption)
								.foregroundColor(.white)
						}
						.padding(.horizontal, 12)
						.padding(.vertical, 6)
						.background(Color.white.opacity(0.3))
						.cornerRadius(15)
						
						Spacer()
					}
				}
				.padding()
				.frame(height: 130)
				.background(color)
				.cornerRadius(10)
				.shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
				.accessibilityElement(children: .combine)
				.accessibilityLabel("\(title): \(Int(progress * 100))% complete")
			}
		}
	}
}

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

/// Model for recent donation items
struct DonationItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let color: Color
}

/// Card showing recent donations
struct RecentDonationsCard: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Recent Donations")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            if let recentDonations = getRecentDonations(), !recentDonations.isEmpty {
                ForEach(0 ..< recentDonations.prefix(4).count, id: \.self) { index in
                    let donation = recentDonations[index]
                    VStack(spacing: 0) {
                        HStack {
                            Text("◆")
                                .foregroundColor(donation.color)
                            
                            Text(donation.title)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(donation.time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                        if index < recentDonations.prefix(4).count - 1 {
                            Divider()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Switch to analytics view
                        categoryManager.showAnalytics()
                    }) {
                        HStack {
                            Text("See Activity")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.acLeafGreen)
                        .cornerRadius(15)
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.title)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No recent donations")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    // Real implementation to get recent donations
    private func getRecentDonations() -> [DonationItem]? {
        // Get all donated items with timestamp
        var donatedItems: [(name: String, date: Date, color: Color)] = []
        
        // Add fossils
        let fossils: [Fossil] = {
            do {
                return try dataManager.getFossilsForCurrentTown()
            } catch {
                print("Error fetching fossils for current town: \(error)")
                return []
            }
        }()
        for fossil in fossils.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fossil.donationDate {
                let name = fossil.part != nil ? "\(fossil.name) \(fossil.part!)" : fossil.name
                donatedItems.append((name: name, date: date, color: .acMuseumBrown))
            }
        }
        
        // Add bugs
        let bugs: [Bug] = {
            do {
                return try dataManager.getBugsForCurrentTown()
            } catch {
                print("Error fetching bugs for current town: \(error)")
                return []
            }
        }()
        for bug in bugs.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = bug.donationDate {
                donatedItems.append((name: bug.name, date: date, color: .green))
            }
        }
        
        // Add fish
        let fish: [Fish] = {
            do {
                return try dataManager.getFishForCurrentTown()
            } catch {
                print("Error fetching fish for current town: \(error)")
                return []
            }
        }()
        for fish in fish.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fish.donationDate {
                donatedItems.append((name: fish.name, date: date, color: .acOceanBlue))
            }
        }
        
        // Add art
        let art: [Art] = {
            do {
                return try dataManager.getArtForCurrentTown()
            } catch {
                print("Error fetching art for current town: \(error)")
                return []
            }
        }()
        for art in art.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = art.donationDate {
                donatedItems.append((name: art.name, date: date, color: .acBlathersPurple))
            }
        }
        
        // Sort by date (most recent first)
        donatedItems.sort { $0.date > $1.date }
        
        // Convert to DonationItem objects with relative time
        return donatedItems.prefix(4).map { item in
            DonationItem(
                title: item.name,
                time: relativeTimeString(from: item.date),
                color: item.color
            )
        }
    }
    
    // Helper to format relative time
    private func relativeTimeString(from date: Date) -> String {
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
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview Providers
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return HomeView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
