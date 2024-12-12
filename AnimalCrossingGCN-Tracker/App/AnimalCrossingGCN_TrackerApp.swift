//
//  AnimalCrossingGCN_TrackerApp.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
//  Last updated 11/18/24
//

import SwiftUI
import SwiftData

@main
struct AnimalCrossingGCN_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Fossil.self,
            Bug.self,
            Fish.self,
            Art.self
        ])
        
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)

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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
