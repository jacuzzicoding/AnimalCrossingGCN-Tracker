//
//  DonateView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 8/17/25.
//

import SwiftUI
import SwiftData

struct DonateView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var categoryManager: CategoryManager
    
    @State private var searchText: String = ""
    @State private var showDonated: Bool = false
    @State private var showBanner: Bool = false
    @State private var bannerMessage: String = ""
    @State private var searchWorkItem: DispatchWorkItem?
    
    // SwiftData queries for each model type
    @Query private var fossils: [Fossil]
    @Query private var bugs: [Bug]
    @Query private var fish: [Fish]
    @Query private var art: [Art]
    
    // Computed property to get filtered items based on selected category
    private var filteredItems: [any CollectibleItem] {
        let allItems: [any CollectibleItem]
        
        switch categoryManager.selectedCategory {
        case .fossils:
            allItems = fossils
        case .bugs:
            allItems = bugs
        case .fish:
            allItems = fish
        case .art:
            allItems = art
        }
        
        return allItems.filter { item in
            // Search filter
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            
            // Donation status filter
            let matchesDonationStatus = showDonated ? item.isDonated : true
            
            return matchesSearch && matchesDonationStatus
        }
        .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategorySelector(selectedCategory: $categoryManager.selectedCategory)
                
                ItemFilterBar(searchText: $searchText, showDonated: $showDonated)
                
                content
            }
            .navigationTitle("Donate to Museum")
            .overlay(alignment: .top) {
                if showBanner {
                    SuccessBanner(message: bannerMessage)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                }
            }
            .onChange(of: searchText) { _, newValue in
                debounceSearch(newValue)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if filteredItems.isEmpty {
            ContentUnavailableView {
                Label("No Items", systemImage: "tray")
            } description: {
                if searchText.isEmpty {
                    Text("No items in this category")
                } else {
                    Text("No items match '\(searchText)'")
                }
            }
        } else {
            List {
                ForEach(filteredItems, id: \.id) { item in
                    DonateItemRow(
                        item: item,
                        category: categoryManager.selectedCategory,
                        onDonate: { donateItem(item) },
                        onUndonate: { undoDonation(item) }
                    )
                    .accessibilityLabel(accessibilityLabel(for: item))
                    .accessibilityHint(accessibilityHint(for: item))
                }
            }
            .listStyle(.plain)
        }
    }
    
    // MARK: - Actions
    
    private func donateItem(_ item: any CollectibleItem) {
        Task { @MainActor in
            if let fossil = item as? Fossil {
                dataManager.updateFossilDonationStatus(fossil, isDonated: true)
            } else if let bug = item as? Bug {
                dataManager.updateBugDonationStatus(bug, isDonated: true)
            } else if let fish = item as? Fish {
                dataManager.updateFishDonationStatus(fish, isDonated: true)
            } else if let art = item as? Art {
                dataManager.updateArtDonationStatus(art, isDonated: true)
            }
            showSuccessMessage("Donated \(item.name)")
            HapticManager.lightImpact()
        }
    }
    
    private func undoDonation(_ item: any CollectibleItem) {
        Task { @MainActor in
            if let fossil = item as? Fossil {
                dataManager.updateFossilDonationStatus(fossil, isDonated: false)
            } else if let bug = item as? Bug {
                dataManager.updateBugDonationStatus(bug, isDonated: false)
            } else if let fish = item as? Fish {
                dataManager.updateFishDonationStatus(fish, isDonated: false)
            } else if let art = item as? Art {
                dataManager.updateArtDonationStatus(art, isDonated: false)
            }
            showSuccessMessage("Undid donation for \(item.name)")
            HapticManager.lightImpact()
        }
    }
    
    private func showSuccessMessage(_ message: String) {
        bannerMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showBanner = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showBanner = false
            }
        }
    }
    
    private func debounceSearch(_ searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            // Search is handled by computed property, no additional action needed
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
    }
    
    // MARK: - Accessibility
    
    private func accessibilityLabel(for item: any CollectibleItem) -> String {
        let status = item.isDonated ? "donated" : "not donated"
        return "\(item.name), \(status)"
    }
    
    private func accessibilityHint(for item: any CollectibleItem) -> String {
        return item.isDonated ? "Double tap to undo donation" : "Double tap to donate"
    }
}

// MARK: - Supporting Views

struct DonateItemRow: View {
    let item: any CollectibleItem
    let category: Category
    let onDonate: () -> Void
    let onUndonate: () -> Void
    
    var body: some View {
        HStack {
            // Category icon
            Circle()
                .fill(iconColor.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: category.symbolName)
                        .foregroundColor(iconColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                if let detailText = itemDetailText {
                    Text(detailText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if item.isDonated, let donationDate = item.donationDate {
                    Text("Donated \(donationDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            // Action button
            if item.isDonated {
                Button("Undo", action: onUndonate)
                    .buttonStyle(.bordered)
                    .tint(.orange)
            } else {
                Button("Donate", action: onDonate)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var iconColor: Color {
        switch category {
        case .fossils: return .brown
        case .bugs: return .green
        case .fish: return .blue
        case .art: return .purple
        }
    }
    
    private var itemDetailText: String? {
        if let fossil = item as? Fossil, let part = fossil.part {
            return part
        } else if let bug = item as? Bug, let season = bug.season {
            return "Season: \(season)"
        } else if let fish = item as? Fish {
            return "Season: \(fish.season)"
        } else if let art = item as? Art {
            return "Based on: \(art.basedOn)"
        }
        return nil
    }
}

struct CategorySelector: View {
    @Binding var selectedCategory: Category
    
    var body: some View {
        Picker("Category", selection: $selectedCategory) {
            ForEach(Category.allCases, id: \.self) { category in
                Text(category.rawValue).tag(category)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct ItemFilterBar: View {
    @Binding var searchText: String
    @Binding var showDonated: Bool
    
    var body: some View {
        HStack {
            TextField("Search items...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
            
            Toggle("Show Donated", isOn: $showDonated)
                .toggleStyle(.switch)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct SuccessBanner: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.green)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}

// MARK: - Haptic Feedback Helper

struct HapticManager {
    static func lightImpact() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}

#if DEBUG
struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return DonateView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
#endif