//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData

// Simple ContentView that delegates to working views
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var dependencyContainer: DependencyContainer
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // iPhone section - delegate to MainTabView
                if let homeViewModel = try? dependencyContainer.resolve(HomeViewModel.self) {
                    MainTabView(selectedTab: .constant(.home), isGlobalSearch: .constant(false))
                } else {
                    Text("Loading...")
                }
            } else {
                // iPad/Mac section - use NavigationSplitView
                NavigationSplitView {
                    List {
                        NavigationLink("Home", value: "home")
                        NavigationLink("Museum", value: "museum") 
                        NavigationLink("Analytics", value: "analytics")
                    }
                } detail: {
                    Text("Select an option from the sidebar")
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Museum Tracker")
            }
        }
    }
}

#Preview {
    ContentView()
}
