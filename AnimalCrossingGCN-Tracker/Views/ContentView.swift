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
//testing if making the category manager an observable object will fix the issue
class CategoryManager: ObservableObject {
    @Published var selectedCategory: Category = .fossils
}

// FloatingCategorySwitcher 
struct FloatingCategorySwitcher: View { 
    @EnvironmentObject var CategoryManager: CategoryManager //environemental object instead of binding, to fix the issue
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Category.allCases, id: \.self) { category in
                Button(action: { //button to switch the category
                    DispatchQueue.main.async { //forces a UI update on the main thread
                        withAnimation(.easeInOut(duration: 0.3)) { //.easeInOut animation for smooth transition. Duration is 0.3 seconds
                            CategoryManager.selectedCategory = category //update the selected category
                         }
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
                #if os(macOS) //v0.5.1 now includes more specific code for macos, should fix the UI issues
                .buttonStyle(PlainButtonStyle())
                .focusable(false)  // This can help with macOS focus issues
                #endif
            }
        }
        .padding()
        #if os(macOS)
        .background(Material.regular.opacity(0.8)) //0.8 opacity for better background visibility on macOS
        #else
        .background(.regularMaterial) //default background for iOS
        #endif
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
struct CategorySection<T: CollectibleItem>: View {
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

//ContentView Struct Block
struct ContentView: View {
    @StateObject private var categoryManager = CategoryManager() //new state object for the category manager
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]
    @Query(sort: \Art.name) private var artQuery: [Art]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.modelContext) private var modelContext
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
            .frame(minWidth: 200) //
            #endif
    }
    
/* DATA LOADING SECTION */
    
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
