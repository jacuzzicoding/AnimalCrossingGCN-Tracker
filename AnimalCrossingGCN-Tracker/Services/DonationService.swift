//
//  DonationService.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/26/25.
//

import Foundation
import SwiftData

/// Service for managing donations across different collectible types
class DonationService {
	private let modelContext: ModelContext
	private let fossilRepository: FossilRepository
	private let bugRepository: BugRepository
	private let fishRepository: FishRepository
	private let artRepository: ArtRepository
	private let townRepository: TownRepository
	
	/// Initializes the service with required repositories
	/// - Parameter modelContext: The SwiftData context to use
	init(modelContext: ModelContext) {
		self.modelContext = modelContext
		self.fossilRepository = FossilRepository(modelContext: modelContext)
		self.bugRepository = BugRepository(modelContext: modelContext)
		self.fishRepository = FishRepository(modelContext: modelContext)
		self.artRepository = ArtRepository(modelContext: modelContext)
		self.townRepository = TownRepository(modelContext: modelContext)
	}
	
	// MARK: - Linking Items to Town
	
	func linkFossilToTown(fossil: Fossil, town: Town) throws {
		fossil.townId = town.id
		do {
			try fossilRepository.save(fossil)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Fossil",
				townName: town.name,
				operation: .link,
				underlyingError: error
			)
		}
	}
	
	func linkBugToTown(bug: Bug, town: Town) throws {
		bug.townId = town.id
		do {
			try bugRepository.save(bug)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Bug",
				townName: town.name,
				operation: .link,
				underlyingError: error
			)
		}
	}
	
	func linkFishToTown(fish: Fish, town: Town) throws {
		fish.townId = town.id
		do {
			try fishRepository.save(fish)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Fish",
				townName: town.name,
				operation: .link,
				underlyingError: error
			)
		}
	}
	
	func linkArtToTown(art: Art, town: Town) throws {
		art.townId = town.id
		do {
			try artRepository.save(art)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Art",
				townName: town.name,
				operation: .link,
				underlyingError: error
			)
		}
	}
	
	// MARK: - Unlinking Items from Town
	
	func unlinkFossilFromTown(fossil: Fossil) throws {
		fossil.townId = nil
		do {
			try fossilRepository.save(fossil)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Fossil",
				townName: "any", // Since we're unlinking, we don't have a specific town name
				operation: .unlink,
				underlyingError: error
			)
		}
	}
	
	func unlinkBugFromTown(bug: Bug) throws {
		bug.townId = nil
		do {
			try bugRepository.save(bug)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Bug",
				townName: "any",
				operation: .unlink,
				underlyingError: error
			)
		}
	}
	
	func unlinkFishFromTown(fish: Fish) throws {
		fish.townId = nil
		do {
			try fishRepository.save(fish)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Fish",
				townName: "any",
				operation: .unlink,
				underlyingError: error
			)
		}
	}
	
	func unlinkArtFromTown(art: Art) throws {
		art.townId = nil
		do {
			try artRepository.save(art)
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
		} catch {
			throw ServiceError.itemLinkingFailed(
				itemType: "Art",
				townName: "any",
				operation: .unlink,
				underlyingError: error
			)
		}
	}
	
	// MARK: - Donation Management
	
	/// Marks an item as donated and timestamps it
	/// - Parameter item: The item to mark as donated
	/// - Throws: ServiceError if the operation fails
	func markItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T) throws {
		do {
			if let fossil = item as? Fossil {
				// Fetch all fossils and find by ID (more reliable than predicates)
				let descriptor = FetchDescriptor<Fossil>()
				if let fossils = try modelContext.fetch(descriptor),
				   let fossilToUpdate = fossils.first(where: { $0.id == fossil.id }) {
					fossilToUpdate.isDonated = true
					fossilToUpdate.donationDate = Date()
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fossil.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let bug = item as? Bug {
				let descriptor = FetchDescriptor<Bug>()
				if let bugs = try modelContext.fetch(descriptor),
				   let bugToUpdate = bugs.first(where: { $0.id == bug.id }) {
					bugToUpdate.isDonated = true
					bugToUpdate.donationDate = Date()
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: bug.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let fish = item as? Fish {
				let descriptor = FetchDescriptor<Fish>()
				if let allFish = try modelContext.fetch(descriptor),
				   let fishToUpdate = allFish.first(where: { $0.id == fish.id }) {
					fishToUpdate.isDonated = true
					fishToUpdate.donationDate = Date()
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fish.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let art = item as? Art {
				let descriptor = FetchDescriptor<Art>()
				if let artPieces = try modelContext.fetch(descriptor),
				   let artToUpdate = artPieces.first(where: { $0.id == art.id }) {
					artToUpdate.isDonated = true
					artToUpdate.donationDate = Date()
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: art.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			}
		} catch let error as ServiceError {
			throw error
		} catch {
			throw ServiceError.donationOperationFailed(
				itemName: item.name,
				operation: .mark,
				underlyingError: error
			)
		}
	}
    
    /// Marks an item as donated with a specific timestamp (for testing)
    func markItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T, withDate date: Date) {
        if let fossil = item as? Fossil {
            // Fetch all fossils and find by ID (more reliable than predicates)
            let descriptor = FetchDescriptor<Fossil>()
            if let fossils = try? modelContext.fetch(descriptor),
               let fossilToUpdate = fossils.first(where: { $0.id == fossil.id }) {
                fossilToUpdate.isDonated = true
                fossilToUpdate.donationDate = date
                try? modelContext.save()
            }
        } else if let bug = item as? Bug {
            let descriptor = FetchDescriptor<Bug>()
            if let bugs = try? modelContext.fetch(descriptor),
               let bugToUpdate = bugs.first(where: { $0.id == bug.id }) {
                bugToUpdate.isDonated = true
                bugToUpdate.donationDate = date
                try? modelContext.save()
            }
        } else if let fish = item as? Fish {
            let descriptor = FetchDescriptor<Fish>()
            if let allFish = try? modelContext.fetch(descriptor),
               let fishToUpdate = allFish.first(where: { $0.id == fish.id }) {
                fishToUpdate.isDonated = true
                fishToUpdate.donationDate = date
                try? modelContext.save()
            }
        } else if let art = item as? Art {
            let descriptor = FetchDescriptor<Art>()
            if let artPieces = try? modelContext.fetch(descriptor),
               let artToUpdate = artPieces.first(where: { $0.id == art.id }) {
                artToUpdate.isDonated = true
                artToUpdate.donationDate = date
                try? modelContext.save()
            }
        }
    }
	
	/// Unmarks an item as donated and removes the timestamp
	/// - Parameter item: The item to unmark as donated
	/// - Throws: ServiceError if the operation fails
	func unmarkItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T) throws {
		do {
			if let fossil = item as? Fossil {
				let descriptor = FetchDescriptor<Fossil>()
				if let fossils = try modelContext.fetch(descriptor),
				   let fossilToUpdate = fossils.first(where: { $0.id == fossil.id }) {
					fossilToUpdate.isDonated = false
					fossilToUpdate.donationDate = nil
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fossil.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let bug = item as? Bug {
				let descriptor = FetchDescriptor<Bug>()
				if let bugs = try modelContext.fetch(descriptor),
				   let bugToUpdate = bugs.first(where: { $0.id == bug.id }) {
					bugToUpdate.isDonated = false
					bugToUpdate.donationDate = nil
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: bug.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let fish = item as? Fish {
				let descriptor = FetchDescriptor<Fish>()
				if let allFish = try modelContext.fetch(descriptor),
				   let fishToUpdate = allFish.first(where: { $0.id == fish.id }) {
					fishToUpdate.isDonated = false
					fishToUpdate.donationDate = nil
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fish.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let art = item as? Art {
				let descriptor = FetchDescriptor<Art>()
				if let artPieces = try modelContext.fetch(descriptor),
				   let artToUpdate = artPieces.first(where: { $0.id == art.id }) {
					artToUpdate.isDonated = false
					artToUpdate.donationDate = nil
					try modelContext.save()
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: art.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			}
		} catch let error as ServiceError {
			throw error
		} catch {
			throw ServiceError.donationOperationFailed(
				itemName: item.name,
				operation: .unmark,
				underlyingError: error
			)
		}
	}
	
	// MARK: - Fetching Items by Town
	
	/// Gets all fossils for a specific town
	/// - Parameter town: The town to get fossils for
	/// - Returns: Array of fossils linked to the town
	/// - Throws: ServiceError if the fetch operation fails
	func getFossilsForTown(town: Town) throws -> [Fossil] {
		// Fetch all fossils and filter by town ID in memory
		let descriptor = FetchDescriptor<Fossil>()
		do {
			let allFossils = try modelContext.fetch(descriptor)
			return allFossils.filter { $0.townId == town.id }
		} catch {
	}
	
	/// Gets all bugs for a specific town
	func getBugsForTown(town: Town) -> [Bug] {
		let descriptor = FetchDescriptor<Bug>()
		do {
			let allBugs = try modelContext.fetch(descriptor)
			return allBugs.filter { $0.townId == town.id }
		} catch {
			print("Error fetching bugs: \(error)")
			return []
		}
	}
	
	/// Gets all fish for a specific town
	func getFishForTown(town: Town) -> [Fish] {
		let descriptor = FetchDescriptor<Fish>()
		do {
			let allFish = try modelContext.fetch(descriptor)
			return allFish.filter { $0.townId == town.id }
		} catch {
			print("Error fetching fish: \(error)")
			return []
		}
	}
	
	/// Gets all art pieces for a specific town
	func getArtForTown(town: Town) -> [Art] {
		let descriptor = FetchDescriptor<Art>()
		do {
			let allArt = try modelContext.fetch(descriptor)
			return allArt.filter { $0.townId == town.id }
		} catch {
			print("Error fetching art: \(error)")
			return []
		}
	}
	
	// MARK: - Progress Tracking
	
	/// Gets donation progress for fossils in a specific town
	func getFossilProgressForTown(town: Town) -> Double {
		let fossils = getFossilsForTown(town: town)
		guard !fossils.isEmpty else { return 0.0 }
		
		let donatedCount = fossils.filter { $0.isDonated }.count
		return Double(donatedCount) / Double(fossils.count)
	}
	
	/// Gets donation progress for bugs in a specific town
	func getBugProgressForTown(town: Town) -> Double {
		let bugs = getBugsForTown(town: town)
		guard !bugs.isEmpty else { return 0.0 }
		
		let donatedCount = bugs.filter { $0.isDonated }.count
		return Double(donatedCount) / Double(bugs.count)
	}
	
	/// Gets donation progress for fish in a specific town
	func getFishProgressForTown(town: Town) -> Double {
		let fish = getFishForTown(town: town)
		guard !fish.isEmpty else { return 0.0 }
		
		let donatedCount = fish.filter { $0.isDonated }.count
		return Double(donatedCount) / Double(fish.count)
	}
	
	/// Gets donation progress for art in a specific town
	func getArtProgressForTown(town: Town) -> Double {
		let artPieces = getArtForTown(town: town)
		guard !artPieces.isEmpty else { return 0.0 }
		
		let donatedCount = artPieces.filter { $0.isDonated }.count
		return Double(donatedCount) / Double(artPieces.count)
	}
	
	/// Gets overall donation progress across all collectible types
	func getTotalProgressForTown(town: Town) -> Double {
		let fossilProgress = getFossilProgressForTown(town: town)
		let bugProgress = getBugProgressForTown(town: town)
		let fishProgress = getFishProgressForTown(town: town)
		let artProgress = getArtProgressForTown(town: town)
		
		let fossils = getFossilsForTown(town: town)
		let bugs = getBugsForTown(town: town)
		let fish = getFishForTown(town: town)
		let artPieces = getArtForTown(town: town)
		
		let fossilWeight = fossilProgress * Double(fossils.count)
		let bugWeight = bugProgress * Double(bugs.count)
		let fishWeight = fishProgress * Double(fish.count)
		let artWeight = artProgress * Double(artPieces.count)
		
		let totalItems = Double(fossils.count + bugs.count + fish.count + artPieces.count)
		guard totalItems > 0 else { return 0.0 }
		
		return (fossilWeight + bugWeight + fishWeight + artWeight) / totalItems
	}
}