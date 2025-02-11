import Foundation
import SwiftData
import Combine
import SwiftUI

class DataManager: ObservableObject {
    // Access to the Model Context
    private var modelContext: ModelContext

    // Published properties to notify views of changes
    @Published var currentTown: Town?

    // Initialize DataManager and fetch the current town
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchCurrentTown()
    }

    /// Fetches the current town from the persistent store.
    /// If no town exists, it creates a default one.
    func fetchCurrentTown() {
        // Create a basic fetch descriptor for Town
        let descriptor = FetchDescriptor<Town>()

        do {
            let towns = try modelContext.fetch(descriptor)
            if let town = towns.first {
                DispatchQueue.main.async {
                    self.currentTown = town
                }
            } else {
                // No town exists; create a default one
                let defaultTown = Town(name: "My Town")
                modelContext.insert(defaultTown)
                try modelContext.save()
                DispatchQueue.main.async {
                    self.currentTown = defaultTown
                }
            }
        } catch {
            print("Error fetching or creating Town: \(error)")
        }
    }


    /// Updates the town's name.
    /// - Parameter newName: The new name for the town.
    func updateTownName(_ newName: String) {
        guard let town = currentTown else { return }
        town.name = newName
        
        do {
            try modelContext.save()
        } catch {
            print("Error updating town name: \(error)")
        }
    }

    /// Adds a new town. (Optional: If you plan to support multiple towns in the future)
    /// - Parameter town: The `Town` object to add.
    func addTown(_ town: Town) {
        modelContext.insert(town)
        
        do {
            try modelContext.save()
            currentTown = town
        } catch {
            print("Error adding new town: \(error)")
        }
    }

    /// Deletes the current town. (Optional: If you plan to support multiple towns)
    func deleteCurrentTown() {
        guard let town = currentTown else { return }
        modelContext.delete(town)
        
        do {
            try modelContext.save()
            fetchCurrentTown()
        } catch {
            print("Error deleting town: \(error)")
        }
    }

    /// Tracks the number of donations made each month and year.
    func trackDonations() {
        let descriptor = FetchDescriptor<DonationTimestampable>()
        
        do {
            let donations = try modelContext.fetch(descriptor)
            let calendar = Calendar.current
            
            let monthlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                if let month = donation.donationMonth {
                    result[month, default: 0] += 1
                }
            }
            
            let yearlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                if let year = donation.donationYear {
                    result[year, default: 0] += 1
                }
            }
            
            print("Monthly Donations: \(monthlyDonations)")
            print("Yearly Donations: \(yearlyDonations)")
        } catch {
            print("Error tracking donations: \(error)")
        }
    }

    /// Identifies peak donation periods and analyzes the factors contributing to these peaks.
    func analyzeDonationTrends() {
        let descriptor = FetchDescriptor<DonationTimestampable>()
        
        do {
            let donations = try modelContext.fetch(descriptor)
            let calendar = Calendar.current
            
            let monthlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                if let month = donation.donationMonth {
                    result[month, default: 0] += 1
                }
            }
            
            let peakMonth = monthlyDonations.max { a, b in a.value < b.value }
            print("Peak Donation Month: \(peakMonth?.key ?? 0) with \(peakMonth?.value ?? 0) donations")
            
            let yearlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                if let year = donation.donationYear {
                    result[year, default: 0] += 1
                }
            }
            
            let peakYear = yearlyDonations.max { a, b in a.value < b.value }
            print("Peak Donation Year: \(peakYear?.key ?? 0) with \(peakYear?.value ?? 0) donations")
        } catch {
            print("Error analyzing donation trends: \(error)")
        }
    }

    /// Compares donation trends across different categories (e.g., fossils, bugs, fish, art).
    func compareDonationTrends() {
        let categories: [Category] = [.fossils, .bugs, .fish, .art]
        
        for category in categories {
            let descriptor = FetchDescriptor<DonationTimestampable>(predicate: NSPredicate(format: "category == %@", category.rawValue))
            
            do {
                let donations = try modelContext.fetch(descriptor)
                let calendar = Calendar.current
                
                let monthlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                    if let month = donation.donationMonth {
                        result[month, default: 0] += 1
                    }
                }
                
                let yearlyDonations = donations.reduce(into: [Int: Int]()) { result, donation in
                    if let year = donation.donationYear {
                        result[year, default: 0] += 1
                    }
                }
                
                print("Category: \(category.rawValue)")
                print("Monthly Donations: \(monthlyDonations)")
                print("Yearly Donations: \(yearlyDonations)")
            } catch {
                print("Error comparing donation trends for category \(category.rawValue): \(error)")
            }
        }
    }
}
