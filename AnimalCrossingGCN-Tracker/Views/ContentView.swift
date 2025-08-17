//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData

/// Main content view that hosts the tab-based navigation
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @EnvironmentObject var dependencyContainer: DependencyContainer
    
    @State private var selectedTab: HomeTab = .home
    @State private var isGlobalSearch: Bool = false
    
    var body: some View {
        ZStack {
            // Main Tab Navigation
            MainTabView(selectedTab: $selectedTab, isGlobalSearch: $isGlobalSearch)
            
            // Global search overlay
            if isGlobalSearch {
                GlobalSearchView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .bottom)
                    ))
                    .onDisappear {
                        isGlobalSearch = false
                    }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isGlobalSearch)
        .onAppear {
            // Initialize data manager if needed
            dataManager.fetchCurrentTown()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        let dependencyContainer = DependencyContainer()
        
        return ContentView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
            .environmentObject(dependencyContainer)
    }
}
#endif
