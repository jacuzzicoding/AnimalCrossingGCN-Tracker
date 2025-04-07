//
//  HomeViewModel.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/6/25.
//

import Foundation
import SwiftUI
import SwiftData

/// View model to manage data and state for the HomeView
@MainActor // Ensures all updates to @Published properties happen on the main thread
class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var collectionStatus: CollectionStatusData = .empty
    @Published var categoryProgress: [CategoryProgressData] = []
    @Published var seasonalHighlights: [SeasonalItem] = []
    @Published var recentDonations: [DonationItem] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil // Holds user-facing error messages

    // MARK: - Dependencies

    private let dataManager: DataManaging // Use the protocol for dependency injection

    // MARK: - Initialization

    /// Initializes the ViewModel with a data manager.
    /// - Parameter dataManager: An object conforming to `DataManaging` to fetch data.
    init(dataManager: DataManaging) {
        self.dataManager = dataManager
        print("HomeViewModel Initialized") // Debug print
    }

    // MARK: - Data Loading Methods

    /// Fetches all necessary data for the HomeView asynchronously.
    /// Updates loading and error states appropriately.
    func loadInitialData() {
        // Prevent multiple simultaneous loads
        guard !isLoading else { return }

        print("HomeViewModel: Starting initial data load...") // Debug print
        isLoading = true
        errorMessage = nil // Clear previous errors

        Task {
            do {
                // Use a Task Group to fetch data concurrently
                async let status = dataManager.fetchCollectionStatus()
                async let progress = dataManager.fetchCategoryProgress()
                async let highlights = dataManager.fetchSeasonalHighlights()
                async let donations = dataManager.fetchRecentDonations()

                // Await all results
                let (fetchedStatus, fetchedProgress, fetchedHighlights, fetchedDonations) = try await (status, progress, highlights, donations)

                // Update published properties on the main actor (guaranteed by @MainActor)
                self.collectionStatus = fetchedStatus
                self.categoryProgress = fetchedProgress
                self.seasonalHighlights = fetchedHighlights
                self.recentDonations = fetchedDonations

                print("HomeViewModel: Data loaded successfully.") // Debug print

            } catch {
                // Handle errors
                print("HomeViewModel: Error loading data - \(error.localizedDescription)") // Debug print
                if let dataError = error as? DataManagerError {
                    self.errorMessage = dataError.localizedDescription
                } else {
                    self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
            }

            // Ensure loading state is turned off regardless of success or failure
            isLoading = false
            print("HomeViewModel: isLoading set to false.") // Debug print
        }
    }

    // MARK: - Navigation Methods
    
    /// Navigate to category view
    func navigateToCategory(_ category: Category, categoryManager: CategoryManager) {
        categoryManager.selectedItem = nil
        categoryManager.selectedCategory = category
        categoryManager.showingAnalytics = false
    }
    
    /// Navigate to analytics view
    func navigateToAnalytics(categoryManager: CategoryManager) {
        categoryManager.showAnalytics()
    }

    // MARK: - Data Refresh
    
    /// Refresh all data
    func refreshData() {
        loadInitialData()
    }
}
