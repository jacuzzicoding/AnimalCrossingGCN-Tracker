//
//  HomeView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//  Updated on 2/27/25.
//
//  This file implements the home screen for the Animal Crossing GCN Tracker app.
//  It provides an overview of the user's museum collection status and quick access
//  to key functionality. The interface adapts for both light and dark mode.

import SwiftUI
import SwiftData

#if canImport(UIKit)
import UIKit
#endif

/// Main home screen view for the Animal Crossing GCN Tracker app
struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @State private var isEditingTown: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with town info
                HomeHeaderView(isEditingTown: $isEditingTown)
                    .padding(.bottom, 4)
                
                // Collection status card
                CollectionStatusCard()
                
                // Category grid
                CategoryGridView()
                    .padding(.vertical, 8)
                
                // Seasonal highlights
                SeasonalHighlightsCard()
                
                // Recent donations
                RecentDonationsCard()
                
                // Spacer for bottom tab bar
                Spacer().frame(height: 20)
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .background(Color(hex: "F9F5E9")) // Parchment background
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditingTown) {
            if let town = dataManager.currentTown {
                EditTownView(isPresented: $isEditingTown, townName: .constant(town.name))
                    .environmentObject(dataManager)
            }
        }
    }
}

// MARK: - Preview Providers
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return HomeView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
