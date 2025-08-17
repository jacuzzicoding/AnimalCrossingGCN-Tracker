//
//  MainTabView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//

import SwiftUI
import SwiftData

/// Main tab view that contains all primary app screens
struct MainTabView: View {
    @Binding var selectedTab: HomeTab
    @Binding var isGlobalSearch: Bool
    @EnvironmentObject var categoryManager: CategoryManager
    @EnvironmentObject var dataManager: DataManager
    
    // Navigation state
    @State private var showSearchSheet: Bool = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(HomeTab.home)
                
                NavigationStack {
                    CategoryListView()
                        .navigationTitle("Museum Categories")
                }
                .tag(HomeTab.museum)
                
                DonateView()
                    .tag(HomeTab.donate)
                
                AnalyticsDashboardView()
                    .tag(HomeTab.analytics)
                
                // Global search placeholder
                Text("")
                    .tag(HomeTab.search)
            }
            .tabViewStyle(.automatic)
            .edgesIgnoringSafeArea(.bottom)
            
            VStack {
                Spacer()
                HomeTabBar(selectedTab: $selectedTab, isGlobalSearch: $isGlobalSearch)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            // Handle tab changes
            if newValue == .search {
                // Show search instead of the tab
                selectedTab = oldValue
                isGlobalSearch = true
            } else if newValue == .analytics {
                categoryManager.showingAnalytics = true
            } else if newValue == .museum {
                categoryManager.showingAnalytics = false
            }
        }
        .sheet(isPresented: $showSearchSheet) {
            Text("Global Search")
                .onDisappear {
                    isGlobalSearch = false
                }
        }
    }
}

/// Placeholder for CategoryListView
struct CategoryListView: View {
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: CategoryDetailView(category: .fossils)) {
                    Label("Fossils", systemImage: "leaf.arrow.circlepath")
                }
                
                NavigationLink(destination: CategoryDetailView(category: .bugs)) {
                    Label("Bugs", systemImage: "ant.fill")
                }
                
                NavigationLink(destination: CategoryDetailView(category: .fish)) {
                    Label("Fish", systemImage: "fish.fill")
                }
                
                NavigationLink(destination: CategoryDetailView(category: .art)) {
                    Label("Art", systemImage: "paintpalette.fill")
                }
            }
        }
    }
}

/// Placeholder for category detail view
struct CategoryDetailView: View {
    let category: Category
    
    var body: some View {
        Text("\(category.rawValue) Detail View")
    }
}

// Real DonateView is now implemented in Views/Donate/DonateView.swift

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return MainTabView(selectedTab: .constant(.home), isGlobalSearch: .constant(false))
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
