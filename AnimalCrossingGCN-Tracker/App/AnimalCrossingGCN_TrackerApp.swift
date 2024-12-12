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

@main //Main app loop here
/*Most of the core code is in ContentView.swift */
struct AnimalCrossingGCN_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Fossil.self,
            Bug.self,
            Fish.self,
            Art.self
        ], version: Schema.Version(2, 0, 0))
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
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
