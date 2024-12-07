//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData

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
    
    // New variable to get the symbol name for each category
    var symbolName: String {
        switch self {
        case .fossils: return "leaf.arrow.circlepath"  //might find a better symbol
        case .bugs: return "ant.fill"
        case .fish: return "fish.fill"
        case .art: return "paintpalette.fill"
        }
    }
    
    func getDefaultData() -> [any CollectibleItem] { //function to get the default data for each category using the new CollectibleItem protocol
        switch self {
        case .fossils: return getDefaultFossils()
        case .bugs: return getDefaultBugs()
        case .fish: return getDefaultFish()
        case .art: return getDefaultArt()
        }
    }
    
    @ViewBuilder //new view builder to return the correct detail view based on the category selected
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
                Image(systemName: "magnifyingglass") //new magnifying glass icon
                    .foregroundColor(.gray)
                TextField("Search...", text: $text)
                    .foregroundColor(.primary)
                    .disableAutocorrection(false) //now allows autocorrection
                if !text.isEmpty { 
                    Button(action: { //new button to clear the text
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill") //if text is not empty, show the xmark to clear the text
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// Custom floating category switcher for improved UI
struct FloatingCategorySwitcher: View { //new struct for the floating category switcher
    @Binding var selectedCategory: Category //binding to the selected category so it updates when the user selects a new category
    
    var body: some View { //new body section for the floating category switcher
        HStack(spacing: 16) { //new horizontal stack with spacing of 16 pixels between each category (can be adjusted)
            ForEach(Category.allCases, id: \.self) { category in //for each category in the Category enum
                Button(action: { //new button to select the category
                    withAnimation { //new animation to smoothly transition between categories
                        selectedCategory = category
                    }
                }) {
                    VStack { //new vertical stack for the category
                        Image(systemName: category.symbolName) 
                            .font(.headline)
                        Text(category.rawValue)
                            .font(.caption)
                    }
                    .padding() //pad
                    .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2)) //if the category is selected, the background will be blue, otherwise it will be gray.
                    .foregroundColor(selectedCategory == category ? .white : .primary) //if the category is selected, the text will be white, otherwise it will be the primary color
                    .cornerRadius(10) //rounding the corners of the category
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
    let item: T //new item variable
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
                if let fossil = item as? Fossil, let part = fossil.part { //so, if the item is a fossil and the part is not nil
                    Text(part) //then display the part
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
struct CategorySection<T: CollectibleItem>: View { //this is the new CategorySection struct
    let category: Category //new category variable
    let items: [T] //an array of items
    @Binding var searchText: String //binding to the search text
    
    var filteredItems: [T] { //new filteredItems variable
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) } //filter the items based on the search text, ignoring case
        }
    }
    
    var body: some View {
        ForEach(filteredItems) { item in //for each item in the filtered items
            NavigationLink { //new navigation link to the detail view
                category.detailView(for: item) //passing the item to the detail view
            } label: {
                CollectibleRow(item: item, category: category)
            }
        }
    }
}

struct ContentView: View { //here is the new ContentView struct
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
                        #if os(macOS)
                        Text("Select an item")
                            .frame(minWidth: 300) //special formatting for macOS
                        #else
                        Text("Select an item") //iOS default formatting
                        #endif
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
            #if os(iOS)
            .listStyle(InsetGroupedListStyle())
            #else
            .listStyle(SidebarListStyle()) // This is more appropriate for macOS
            #endif
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
