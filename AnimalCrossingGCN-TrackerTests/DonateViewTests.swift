//
//  DonateViewTests.swift
//  AnimalCrossingGCN-TrackerTests
//
//  Created on 8/17/25.
//

import XCTest
import SwiftData
@testable import AnimalCrossingGCN_Tracker

final class DonateViewTests: XCTestCase {
    var modelContext: ModelContext!
    var dataManager: DataManager!
    var categoryManager: CategoryManager!
    
    override func setUp() {
        super.setUp()
        
        // Create in-memory model container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        modelContext = container.mainContext
        dataManager = DataManager(modelContext: modelContext)
        categoryManager = CategoryManager()
        
        // Create a test town
        let town = Town(name: "TestTown", playerName: "Test Player", game: .ACGCN)
        modelContext.insert(town)
        
        // Add some test fossils
        let fossil1 = Fossil(name: "Test Fossil 1", isDonated: false, games: [.ACGCN])
        let fossil2 = Fossil(name: "Test Fossil 2", isDonated: true, games: [.ACGCN])
        modelContext.insert(fossil1)
        modelContext.insert(fossil2)
        
        try! modelContext.save()
        dataManager.fetchCurrentTown()
    }
    
    func testCategoryManagerSelection() {
        // Test that category switching works
        XCTAssertEqual(categoryManager.selectedCategory, .fossils)
        
        categoryManager.switchCategory(.bugs)
        XCTAssertEqual(categoryManager.selectedCategory, .bugs)
        
        categoryManager.switchCategory(.fish)
        XCTAssertEqual(categoryManager.selectedCategory, .fish)
        
        categoryManager.switchCategory(.art)
        XCTAssertEqual(categoryManager.selectedCategory, .art)
    }
    
    func testFossilDonationToggle() {
        // Get fossils from data manager
        let fossils = dataManager.getFossilsForCurrentTown()
        XCTAssertGreaterThan(fossils.count, 0, "Should have test fossils")
        
        let fossil = fossils.first!
        let originalDonationStatus = fossil.isDonated
        
        // Toggle donation status
        dataManager.updateFossilDonationStatus(fossil, isDonated: !originalDonationStatus)
        
        // Verify the change
        XCTAssertEqual(fossil.isDonated, !originalDonationStatus)
        
        // Verify donation date is set when donated
        if !originalDonationStatus {
            XCTAssertNotNil(fossil.donationDate, "Donation date should be set when item is donated")
        }
    }
    
    func testSearchAndFilterFunctionality() {
        // This tests the logic that would be used in the search functionality
        let fossils = dataManager.getFossilsForCurrentTown()
        
        // Test search filter
        let searchText = "Test Fossil 1"
        let searchResults = fossils.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        XCTAssertEqual(searchResults.count, 1)
        XCTAssertEqual(searchResults.first?.name, "Test Fossil 1")
        
        // Test donation status filter
        let donatedFossils = fossils.filter { $0.isDonated }
        let undonatedFossils = fossils.filter { !$0.isDonated }
        
        XCTAssertGreaterThan(donatedFossils.count + undonatedFossils.count, 0)
        XCTAssertEqual(donatedFossils.count + undonatedFossils.count, fossils.count)
    }
    
    func testHapticManagerSafety() {
        // Test that haptic feedback doesn't crash on different platforms
        XCTAssertNoThrow(HapticManager.lightImpact())
    }
}