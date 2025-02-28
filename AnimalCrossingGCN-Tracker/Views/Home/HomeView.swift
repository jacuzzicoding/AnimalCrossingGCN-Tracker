//
//  HomeView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//

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
                
                // Seasonal highlights
                SeasonalHighlightsCard()
                
                // Recent donations
                RecentDonationsCard()
                
                // Spacer for bottom tab bar
                Spacer().frame(height: 20)
            }
            .padding()
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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dataManager.currentTown?.name ?? "My Town")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Mayor: \(dataManager.currentTown?.playerName ?? "Player")")
                    .font(.subheadline)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Museum Collection Status")
                .font(.headline)
            
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
                if let completion = dataManager.getCategoryCompletionData() {
                    Text("\(completion.totalDonated) of \(completion.totalCount) Items Donated")
                        .font(.subheadline)
                } else {
                    Text("0 of 0 Items Donated")
                        .font(.subheadline)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

/// Grid of category cards with completion status
struct CategoryGridView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
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

    // New computed property for donation info
    private var donationInfo: String? {
        guard let completion = dataManager.getCategoryCompletionData() else { return nil }
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
    }

    // Add this computed property to determine if text should be dark
    private var shouldUseDarkText: Bool {
        // Simple check for known light colors, or implement a brightness check
        return color == .acBellYellow || color.brightness > 0.7
    }

    var body: some View {
        Button(action: {
            categoryManager.switchCategory(category)
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(shouldUseDarkText ? .black : .white)
                
                Spacer()
                
                Text(emoji)
                    .font(.system(size: 24))
                
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(shouldUseDarkText ? .black : .white)
                
                if let info = donationInfo {
                    Text(info)
                        .font(.caption)
                        .foregroundColor(shouldUseDarkText ? .black.opacity(0.8) : .white.opacity(0.9))
                }
                
                Spacer()
                
                HStack {
                    Text("View All")
                        .font(.caption)
                        .foregroundColor(shouldUseDarkText ? .black.opacity(0.8) : .white.opacity(0.9))
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(shouldUseDarkText ? .black.opacity(0.8) : .white.opacity(0.9))
                }
                .padding(.top, 4)
            }
            .padding()
            .frame(height: 150)
            .background(color)
            .cornerRadius(10)
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

// Add this extension to calculate color brightness
extension Color {
    var brightness: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        #if canImport(UIKit)
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        #else
        NSColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        #endif
        
        // Formula to determine perceived brightness
        return (0.299 * red + 0.587 * green + 0.114 * blue)
    }
}

/// Card showing seasonal highlights
struct SeasonalHighlightsCard: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Seasonal Highlights")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { i in
                        SeasonalItemView(
                            title: seasonalItems[i].title,
                            description: seasonalItems[i].description,
                            color: seasonalItems[i].color
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    private var seasonalItems: [(title: String, description: String, color: Color)] {
        // In a real app, this would come from actual data
        [
            ("Common Butterfly", "Available Now!", .acLeafGreen),
            ("Mole Cricket", "Leaving in 3 days!", .acPumpkinOrange),
            ("Emperor Butterfly", "Coming in April!", .acBlathersPurple)
        ]
    }
}

/// Individual seasonal item component
struct SeasonalItemView: View {
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .frame(width: 120, height: 80)
        .background(Color.white.opacity(0.8))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct DonationItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let color: Color
}

/// Card showing recent donations
struct RecentDonationsCard: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Donations")
                .font(.headline)
            
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
                ForEach(0 ..< recentDonations.prefix(4).count, id: \.self) { index in
                    let donation = recentDonations[index]
                    VStack(spacing: 0) {
                        HStack {
                            Text("◆")
                                .foregroundColor(donation.color)
                            
                            Text(donation.title)
                                .font(.subheadline)
                            
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
                        // Open analytics
                    }) {
                        HStack {
                            Text("See Activity")
                                .font(.caption)
                                .foregroundColor(.acLeafGreen)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.acLeafGreen)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    private var recentDonations: [DonationItem] {
        // In a real app, this would come from actual data
        [
            DonationItem(title: "Saber-Tooth Tiger Skull", time: "3 hours ago", color: .acMuseumBrown),
            DonationItem(title: "Emperor Butterfly", time: "Yesterday", color: .green),
            DonationItem(title: "Sea Bass", time: "Yesterday", color: .acOceanBlue),
            DonationItem(title: "T-Rex Tail", time: "2 days ago", color: .acMuseumBrown)
        ]
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data setup
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
