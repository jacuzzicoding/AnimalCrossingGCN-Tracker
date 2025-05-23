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
    @StateObject private var viewModel: HomeViewModel
    @State private var isEditingTown: Bool = false
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HomeHeaderView(isEditingTown: $isEditingTown)
                    .padding(.bottom, 4)
                // Error banner
                if viewModel.errorState != .none {
                    ErrorBanner(state: viewModel.errorState)
                }
                // Collection status card
                if let completion = viewModel.categoryCompletion {
                    CollectionStatusCardView(completion: completion)
                }
                // Category grid
                CategoryGridSection(viewModel: viewModel, categoryManager: categoryManager)
                    .padding(.vertical, 8)
                // Seasonal highlights
                SeasonalHighlightsSection(seasonalItems: viewModel.seasonalItems)
                // Recent donations
                RecentDonationsSection(recentDonations: viewModel.recentDonations, categoryManager: categoryManager)
                Spacer().frame(height: 20)
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .background(Color(hex: "F9F5E9"))
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditingTown) {
            if let town = dataManager.currentTown {
                EditTownView(isPresented: $isEditingTown, townName: .constant(town.name))
                    .environmentObject(dataManager)
            }
        }
        .onAppear {
            viewModel.loadAllData()
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

// MARK: - CollectionStatusCardView
struct CollectionStatusCardView: View {
    let completion: CategoryCompletionData
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
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .opacity(0.2)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                    Rectangle()
                        .frame(width: min(CGFloat(completion.totalProgress) * geometry.size.width, geometry.size.width), height: 20)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: completion.totalProgress)
                    HStack {
                        Spacer()
                        Text("\(Int(completion.totalProgress * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 20)
            HStack {
                Text("\(completion.totalDonated) of \(completion.totalCount) Items Donated")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Museum Collection Status: \(Int(completion.totalProgress * 100))% complete")
    }
}

// MARK: - CategoryGridSection
struct CategoryGridSection: View {
    @ObservedObject var viewModel: HomeViewModel
    var categoryManager: CategoryManager
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
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                CategoryCard(
                    title: "FOSSILS",
                    icon: "leaf.arrow.circlepath",
                    progress: viewModel.categoryCompletion?.fossilProgress ?? 0,
                    color: .acMuseumBrown,
                    emoji: "🦴",
                    donationInfo: viewModel.categoryCompletion.map { "\($0.fossilDonated)/\($0.fossilCount)" },
                    onTap: {
                        categoryManager.selectedItem = nil
                        categoryManager.selectedCategory = .fossils
                        categoryManager.showingAnalytics = false
                    }
                )
                CategoryCard(
                    title: "BUGS",
                    icon: "ant.fill",
                    progress: viewModel.categoryCompletion?.bugProgress ?? 0,
                    color: .green,
                    emoji: "🐛",
                    donationInfo: viewModel.categoryCompletion.map { "\($0.bugDonated)/\($0.bugCount)" },
                    onTap: {
                        categoryManager.selectedItem = nil
                        categoryManager.selectedCategory = .bugs
                        categoryManager.showingAnalytics = false
                    }
                )
                CategoryCard(
                    title: "FISH",
                    icon: "fish.fill",
                    progress: viewModel.categoryCompletion?.fishProgress ?? 0,
                    color: .acOceanBlue,
                    emoji: "🐟",
                    donationInfo: viewModel.categoryCompletion.map { "\($0.fishDonated)/\($0.fishCount)" },
                    onTap: {
                        categoryManager.selectedItem = nil
                        categoryManager.selectedCategory = .fish
                        categoryManager.showingAnalytics = false
                    }
                )
                CategoryCard(
                    title: "ART",
                    icon: "paintpalette.fill",
                    progress: viewModel.categoryCompletion?.artProgress ?? 0,
                    color: .acBlathersPurple,
                    emoji: "🎨",
                    donationInfo: viewModel.categoryCompletion.map { "\($0.artDonated)/\($0.artCount)" },
                    onTap: {
                        categoryManager.selectedItem = nil
                        categoryManager.selectedCategory = .art
                        categoryManager.showingAnalytics = false
                    }
                )
            }
        }
    }
}

// MARK: - SeasonalHighlightsSection
struct SeasonalHighlightsSection: View {
    let seasonalItems: [SeasonalItem]
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
                    if seasonalItems.isEmpty {
                        Text("No seasonal items available")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(seasonalItems) { item in
                            SeasonalItemView(
                                title: item.name,
                                description: item.description,
                                color: item.isLeaving ? .acPumpkinOrange : .acLeafGreen
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

// MARK: - RecentDonationsSection
struct RecentDonationsSection: View {
    let recentDonations: [DonationItem]
    var categoryManager: CategoryManager
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
            if recentDonations.isEmpty {
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
            } else {
                ForEach(recentDonations) { donation in
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
                        if donation.id != recentDonations.last?.id {
                            Divider()
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
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
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
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
        
        // Manually create dependencies for preview
        let donationService = DonationServiceImpl(modelContext: context)
        let analyticsService = AnalyticsServiceImpl(modelContext: context, donationService: donationService)
        let homeViewModel = HomeViewModel(dataManager: dataManager, analyticsService: analyticsService, donationService: donationService)
        
        return HomeView(viewModel: homeViewModel)
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
