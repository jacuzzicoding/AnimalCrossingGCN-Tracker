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
    
    // Dictionary to hold arrays of items for each category
    @State private var museumItems: [String: [Fossil]] = [
        "Fossils": [], // You'll populate this with the predefined fossils
        "Bugs": [],
        "Fish": [],
        "Art": []
    ]

    var body: some View {
        NavigationSplitView {
            List {
                // Fossils Section
                Section(header: Text("Fossils")) {
                    ForEach(museumItems["Fossils"] ?? [], id: \.id) { fossil in
                        NavigationLink {
                            Text("\(fossil.name) - \(fossil.part ?? "")")
                        } label: {
                            Text("\(fossil.name) - \(fossil.part ?? "")")
                        }
                    }
                    .onDelete { offsets in
                        deleteItems(category: "Fossils", offsets: offsets)
                    }
                }
                
                // Bugs Section
                Section(header: Text("Bugs")) {
                    ForEach(museumItems["Bugs"] ?? [], id: \.self) { item in
                        NavigationLink {
                            Text("Bug caught at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete { offsets in
                        deleteItems(category: "Bugs", offsets: offsets)
                    }
                }
                
                // Fish Section
                Section(header: Text("Fish")) {
                    ForEach(museumItems["Fish"] ?? [], id: \.self) { item in
                        NavigationLink {
                            Text("Fish caught at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete { offsets in
                        deleteItems(category: "Fish", offsets: offsets)
                    }
                }
                
                // Art Section
                Section(header: Text("Art")) {
                    ForEach(museumItems["Art"] ?? [], id: \.self) { item in
                        NavigationLink {
                            Text("Artwork collected at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete { offsets in
                        deleteItems(category: "Art", offsets: offsets)
                    }
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    // Function to add an item to a specific category
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date()) // Later modify this to add specific data
            museumItems["Fossils"]?.append(newItem) // Placeholder, allow user to choose category
            modelContext.insert(newItem)
        }
    }

    // Function to delete items from a specific category
    private func deleteItems(category: String, offsets: IndexSet) {
        withAnimation {
            museumItems[category]?.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
