//
//  AnimalCrossingGCN_TrackerApp.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
//  Last updated 12/15/24
//

import SwiftUI
import SwiftData
import Charts

@main
struct AnimalCrossingGCN_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Fossil.self,
            Bug.self,
            Fish.self,
            Art.self,
            Town.self
        ])
        
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            return container
        } catch {
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // Initialize DataManager with the shared ModelContainer's context
    @StateObject private var dataManager: DataManager

    init() {
        let context = sharedModelContainer.mainContext
        _dataManager = StateObject(wrappedValue: DataManager(modelContext: context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager) // Inject DataManager into the environment
        }
        .modelContainer(sharedModelContainer)
    }
}
