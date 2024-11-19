//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData // Using SwiftData to handle user data. Testing shows it works quite well with very simple implementation!

//Using a protocol to define the properties that all collectible items share. Kinda like a superclass in Java or C++
protocol CollectibleItem: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var isDonated: Bool { get set }
}

//Need to use extensions so that the protocol can be used by our different item types
extension Fossil: CollectibleItem {}
extension Bug: CollectibleItem {}
extension Fish: CollectibleItem {}
extension Art: CollectibleItem {}

//Now using an enum to handle the different categories of items, this should simplify the code a lot soon!!
enum Category: String, CaseIterable {
    case fossils = "Fossils"
    case bugs = "Bugs"
    case fish = "Fish"
    case art = "Art"
    
    // Returns default data for each category type
    func getDefaultData() -> [any CollectibleItem] {
        switch self {
        case .fossils:
            return getDefaultFossils()
        case .bugs:
            return getDefaultBugs()
        case .fish:
            return getDefaultFish()
        case .art:
            return getDefaultArt()
        }
    }
    
    // Returns appropriate detail view for each category type using ViewBuilder
    @ViewBuilder
    func detailView<T: CollectibleItem>(for item: T) -> some View {
        switch self {  //simple switch statement to return the correct view for each case
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
                FishDetailView(Fish: fish)  // Keeping 'Fish' capitalization for now, as fixing it breaks it
            }
        case .art:
            if let art = item as? Art {
                ArtDetailView(art: art)
            }
        }
    }
}

//New reusable section view for each category! Going to refractor the other functions like this soon
struct CategorySection<T: CollectibleItem>: View {
    let category: Category
    let items: [T]
    @Binding var searchText: String
    
    // Filtered items based on search text
    var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        Section(header: Text(category.rawValue)) {
            ForEach(filteredItems) { item in
                HStack {
                    // NavigationLink to navigate to the appropriate detail view
                    NavigationLink {
                        category.detailView(for: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            // Category-specific detail information
                            if let fossil = item as? Fossil, let part = fossil.part {
                                Text(part)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let bug = item as? Bug, let season = bug.season {
                                Text("Season: \(season)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let fish = item as? Fish {
                                Text("Season: \(fish.season)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    Spacer()
                    // Toggle to mark as donated, placed outside NavigationLink
                    Toggle(isOn: Binding(
                        get: { item.isDonated },
                        set: { newValue in
                            if var mutableItem = item as? any CollectibleItem {
                                mutableItem.isDonated = newValue
                            }
                        }
                    )) {
                        Text("")
                    }
                    .labelsHidden()
                }
            }
        }
    }
}

/* ContentView struct is the main view of the app, containing the search bar, category filter, and main list view.
   It also loads all predefined data into SwiftData when the view appears. */
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]  // Queries to fetch fossils/bugs/fish/paintings from SwiftData
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]
    @Query(sort: \Art.name) private var artQuery: [Art]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass  // Detect size class (compact = iPhone, regular = iPad/Mac)
    
    @State private var selectedFossil: Fossil?  // Bindable properties for selected items
    @State private var selectedBug: Bug?
    @State private var selectedFish: Fish?
    @State private var selectedArt: Art?
    
    @State private var searchText = ""  // State property for search text
    @State private var selectedCategories: Set<String> = Set(Category.allCases.map { $0.rawValue })  // State property for selected categories
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // IPHONE SECTION, using NavigationStack
                NavigationStack {
                    VStack {
                        searchBar
                        categoryFilter
                        mainList
                    }
                    .navigationTitle("Museum Tracker")
                }
            } else {
                // Using NavigationSplitView for macOS and iPadOS devices (regular width)
                NavigationSplitView {
                    VStack {
                        searchBar
                        categoryFilter
                        mainList
                    }
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                    #endif
                } detail: {
                    if let fossil = selectedFossil {
                        FossilDetailView(fossil: fossil)
                    } else if let bug = selectedBug {
                        BugDetailView(bug: bug)
                    } else if let fish = selectedFish {
                        FishDetailView(Fish: fish)  // Keeping 'Fish' uppercase for now
                    } else if let art = selectedArt {
                        ArtDetailView(art: art)
                    } else {
                        Text("Select an item")
                    }
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .onAppear {
            loadData()  // Load all data when view appears
        }
    }
    
    // MARK: - Views
    
    // Search bar view
    private var searchBar: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
    
    // Category filter view with horizontal scrolling buttons
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Category.allCases, id: \.self) { category in
                    Toggle(category.rawValue, isOn: Binding(
                        get: { selectedCategories.contains(category.rawValue) },
                        set: { isOn in
                            if isOn {
                                selectedCategories.insert(category.rawValue)
                            } else {
                                selectedCategories.remove(category.rawValue)
                            }
                        }
                    ))
                    .toggleStyle(ButtonToggleStyle())
                    .padding(.horizontal, 8)
                }
            }
            .padding()
        }
    }
    
    // Main list view containing all category sections
    private var mainList: some View {
        List {
            ForEach(Category.allCases, id: \.self) { category in
                if selectedCategories.contains(category.rawValue) {
                    switch category {
                    case .fossils:
                        CategorySection(category: category, items: fossilsQuery, searchText: $searchText)
                    case .bugs:
                        CategorySection(category: category, items: bugsQuery, searchText: $searchText)
                    case .fish:
                        CategorySection(category: category, items: fishQuery, searchText: $searchText)
                    case .art:
                        CategorySection(category: category, items: artQuery, searchText: $searchText)
                    }
                }
            }
        }
    }
    
    // MARK: - Data Loading
    
    // Function to load all predefined data into SwiftData if not already present
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
        try? modelContext.save()  // Save all new items to the context
    }
}

// Custom toggle style for the category filter buttons
struct ButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(configuration.isOn ? Color.blue : Color.gray.opacity(0.2))
                )
        }
        .foregroundColor(configuration.isOn ? .white : .primary)
    }
}
