//
//  ContentView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]  // Query to fetch fossils from SwiftData

    @Environment(\.horizontalSizeClass) var horizontalSizeClass  // Detect size class (compact = iPhone, regular = iPad/Mac)
    
    @State private var selectedFossil: Fossil?  // Bindable property for selected fossil

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // Use NavigationStack for iPhone (compact width)
                NavigationStack {
                    List {
                        fossilsSection
                    }
                    .frame(maxHeight: .infinity)  // Ensure the List takes up all available space
                    .navigationTitle("Museum Tracker")
                }
            } else {
                // Using NavigationSplitView for macOS and iPadOS devices (regular width)
                NavigationSplitView {
                    List {
                        fossilsSection
                    }
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                    #endif
                } detail: {
                    if let fossil = selectedFossil {
                        FossilDetailView(fossil: fossil)
                    } else {
                        Text("Select an item")
                    }
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .onAppear {
            loadFossils() // This ensures fossils are loaded on all devices
        }
    }

    // Separate fossils section for reusability
    private var fossilsSection: some View {
        Section(header: Text("Fossils")) {
            ForEach(fossilsQuery, id: \.id) { fossil in
                Button(action: {
                    selectedFossil = fossil // Set the selected fossil
                }) {
                    Toggle(isOn: Binding(
                        get: { fossil.isDonated },
                        set: { newValue in
                            fossil.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(fossil.name)
                            if let part = fossil.part {
                                Text(part)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .onDelete { offsets in
                deleteItems(offsets: offsets)  // Handle deletion of fossils
            }
        }
    }

    // Function to load predefined fossils into SwiftData if not already present
    private func loadFossils() {
        if fossilsQuery.isEmpty {
            let fossils = getDefaultFossils()  // Fetch default fossils from Fossils.swift
            for fossil in fossils {
                modelContext.insert(fossil) // Insert fossils into SwiftData context
            }
        }
    }

    // Function to add a fossil manually
    private func addFossil() {
        withAnimation {
            let newFossil = Fossil(name: "New Fossil", part: "Part", isDonated: false)
            modelContext.insert(newFossil) // Insert new fossil into SwiftData
        }
    }

    // Function to delete items from SwiftData
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fossilsQuery[$0] }.forEach(modelContext.delete)  // Remove selected items
        }
    }
}

#Preview {
    ContentView()
}
