//
//  ContentView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
//  Last updated 11/19/24

import Foundation
import SwiftUI
import SwiftData

// Keeping existing protocol and extensions
protocol CollectibleItem: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var isDonated: Bool { get set }
}

extension Fossil: CollectibleItem {}
extension Bug: CollectibleItem {}
extension Fish: CollectibleItem {}
extension Art: CollectibleItem {}

// Enhanced Category enum with symbols built into swift
enum Category: String, CaseIterable {
    case fossils = "Fossils"
    case bugs = "Bugs"
    case fish = "Fish"
    case art = "Art"
    
    var symbolName: String {
        switch self {
        case .fossils: return "leaf.arrow.circlepath" //
        case .bugs: return "ant.fill"
        case .fish: return "fish.fill"
        case .art: return "paintpalette.fill"
        }
    }
    
    // Keeping existing functions
    func getDefaultData() -> [any CollectibleItem] {
        switch self {
        case .fossils: return getDefaultFossils()
        case .bugs: return getDefaultBugs()
        case .fish: return getDefaultFish()
        case .art: return getDefaultArt()
        }
    }
    
    @ViewBuilder
    func detailView<T: CollectibleItem>(for item: T) -> some View {
        switch self {
        case .fossils:
            if let fossil = item as? Fossil {
                FossilDetailView(fossil: fossil)
            }
        case .bugs:
            if let bug = item as? Bug {
                BugDetailView(bug: bug)
            }
        case .fish:
            if let fish = item as? Fish {
                FishDetailView(Fish: fish)
            }
        case .art:
            if let art = item as? Art {
                ArtDetailView(art: art)
            }
        }
    }
}

// Custom SearchBar view for improved UI
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search...", text: $text)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// Custom floating category switcher
struct FloatingCategorySwitcher: View {
    @Binding var selectedCategory: Category
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Category.allCases, id: \.self) { category in
                Button(action: {
                    withAnimation {
                        selectedCategory = category
                    }
                }) {
                    VStack {
                        Image(systemName: category.symbolName)
                            .font(.headline)
                        Text(category.rawValue)
                            .font(.caption)
                    }
                    .padding()
                    .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(selectedCategory == category ? .white : .primary)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// Enhanced CollectibleRow for better visual presentation
struct CollectibleRow<T: CollectibleItem>: View {
    let item: T
    let category: Category
    
    var body: some View {
        HStack {
            // Category icon with colored background
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: category.symbolName)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                // Category-specific details (keeping existing logic)
                if let fossil = item as? Fossil, let part = fossil.part {
                    Text(part)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let bug = item as? Bug, let season = bug.season {
                    Text("Season: \(season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let fish = item as? Fish {
                    Text("Season: \(fish.season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let art = item as? Art {
                    Text("Based on: \(art.basedOn)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Enhanced donation indicator
            Image(systemName: item.isDonated ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDonated ? .green : .gray)
                .font(.title3)
        }
        .padding(.vertical, 8)
    }
}

// Updated CategorySection with enhanced row presentation
struct CategorySection<T: CollectibleItem>: View {
    let category: Category
    let items: [T]
    @Binding var searchText: String
    
    var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ForEach(filteredItems) { item in
            NavigationLink {
                category.detailView(for: item)
            } label: {
                CollectibleRow(item: item, category: category)
            }
        }
    }
}

struct ContentView: View {
    // Keeping existing environment and query properties
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]
    @Query(sort: \Art.name) private var artQuery: [Art]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // Updated state properties
    @State private var selectedCategory: Category = .fossils
    @State private var searchText = ""
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // IPHONE SECTION
                NavigationStack {
                    mainContent
                        .navigationTitle("Museum Tracker")
                }
            } else {
                // MAC/IPAD SECTION
                NavigationSplitView {
                    mainContent
                        #if os(macOS)
                        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                        #endif
                } detail: {
                    Text("Select an item")
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    // MARK: - Views
    
    private var mainContent: some View {
        ZStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                mainList
            }
            
            // Floating category switcher overlay
            VStack {
                Spacer()
                FloatingCategorySwitcher(selectedCategory: $selectedCategory)
                    .padding(.bottom, 20)
            }
        }
    }
    
    private var mainList: some View {
        List {
            switch selectedCategory {
            case .fossils:
                CategorySection(category: .fossils, items: fossilsQuery, searchText: $searchText)
            case .bugs:
                CategorySection(category: .bugs, items: bugsQuery, searchText: $searchText)
            case .fish:
                CategorySection(category: .fish, items: fishQuery, searchText: $searchText)
            case .art:
                CategorySection(category: .art, items: artQuery, searchText: $searchText)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // MARK: - Data Loading
    
    // Keeping existing loadData function
    private func loadData() {
        for category in Category.allCases {
            let data = category.getDefaultData()
            switch category {
            case .fossils:
                if fossilsQuery.isEmpty {
                    data.compactMap { $0 as? Fossil }.forEach { modelContext.insert($0) }
                }
            case .bugs:
                if bugsQuery.isEmpty {
                    data.compactMap { $0 as? Bug }.forEach { modelContext.insert($0) }
                }
            case .fish:
                if fishQuery.isEmpty {
                    data.compactMap { $0 as? Fish }.forEach { modelContext.insert($0) }
                }
            case .art:
                if artQuery.isEmpty {
                    data.compactMap { $0 as? Art }.forEach { modelContext.insert($0) }
                }
            }
        }
        try? modelContext.save()
    }
}
