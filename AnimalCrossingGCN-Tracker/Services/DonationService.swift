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
				// Find by ID using repository
				if let fossilToUpdate = fossilRepository.getById(id: fossil.id) {
					fossilToUpdate.isDonated = true
					fossilToUpdate.donationDate = Date()
					try fossilRepository.save(fossilToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fossil.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let bug = item as? Bug {
				if let bugToUpdate = bugRepository.getById(id: bug.id) {
					bugToUpdate.isDonated = true
					bugToUpdate.donationDate = Date()
					try bugRepository.save(bugToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: bug.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let fish = item as? Fish {
				if let fishToUpdate = fishRepository.getById(id: fish.id) {
					fishToUpdate.isDonated = true
					fishToUpdate.donationDate = Date()
					try fishRepository.save(fishToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fish.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			} else if let art = item as? Art {
				if let artToUpdate = artRepository.getById(id: art.id) {
					artToUpdate.isDonated = true
					artToUpdate.donationDate = Date()
					try artRepository.save(artToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: art.name,
						operation: .mark,
						underlyingError: nil
					)
				}
			}
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
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
    /// - Parameters:
    ///   - item: The item to mark as donated
    ///   - date: The date to set as the donation date
    /// - Throws: ServiceError if the operation fails
    func markItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T, withDate date: Date) throws {
        do {
            if let fossil = item as? Fossil {
                // Find by ID using repository
                if let fossilToUpdate = fossilRepository.getById(id: fossil.id) {
                    fossilToUpdate.isDonated = true
                    fossilToUpdate.donationDate = date
                    try fossilRepository.save(fossilToUpdate)
                } else {
                    throw ServiceError.donationOperationFailed(
                        itemName: fossil.name,
                        operation: .timestamp,
                        underlyingError: nil
                    )
                }
            } else if let bug = item as? Bug {
                if let bugToUpdate = bugRepository.getById(id: bug.id) {
                    bugToUpdate.isDonated = true
                    bugToUpdate.donationDate = date
                    try bugRepository.save(bugToUpdate)
                } else {
                    throw ServiceError.donationOperationFailed(
                        itemName: bug.name,
                        operation: .timestamp,
                        underlyingError: nil
                    )
                }
            } else if let fish = item as? Fish {
                if let fishToUpdate = fishRepository.getById(id: fish.id) {
                    fishToUpdate.isDonated = true
                    fishToUpdate.donationDate = date
                    try fishRepository.save(fishToUpdate)
                } else {
                    throw ServiceError.donationOperationFailed(
                        itemName: fish.name,
                        operation: .timestamp,
                        underlyingError: nil
                    )
                }
            } else if let art = item as? Art {
                if let artToUpdate = artRepository.getById(id: art.id) {
                    artToUpdate.isDonated = true
                    artToUpdate.donationDate = date
                    try artRepository.save(artToUpdate)
                } else {
                    throw ServiceError.donationOperationFailed(
                        itemName: art.name,
                        operation: .timestamp,
                        underlyingError: nil
                    )
                }
            }
        } catch let error as RepositoryError {
            throw ServiceError.repositoryError(error)
        } catch let error as ServiceError {
            throw error
        } catch {
            throw ServiceError.donationOperationFailed(
                itemName: item.name,
                operation: .timestamp,
                underlyingError: error
            )
        }
    }
	
	/// Unmarks an item as donated and removes the timestamp
	/// - Parameter item: The item to unmark as donated
	/// - Throws: ServiceError if the operation fails
	func unmarkItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T) throws {
		do {
			if let fossil = item as? Fossil {
				if let fossilToUpdate = fossilRepository.getById(id: fossil.id) {
					fossilToUpdate.isDonated = false
					fossilToUpdate.donationDate = nil
					try fossilRepository.save(fossilToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fossil.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let bug = item as? Bug {
				if let bugToUpdate = bugRepository.getById(id: bug.id) {
					bugToUpdate.isDonated = false
					bugToUpdate.donationDate = nil
					try bugRepository.save(bugToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: bug.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let fish = item as? Fish {
				if let fishToUpdate = fishRepository.getById(id: fish.id) {
					fishToUpdate.isDonated = false
					fishToUpdate.donationDate = nil
					try fishRepository.save(fishToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: fish.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			} else if let art = item as? Art {
				if let artToUpdate = artRepository.getById(id: art.id) {
					artToUpdate.isDonated = false
					artToUpdate.donationDate = nil
					try artRepository.save(artToUpdate)
				} else {
					throw ServiceError.donationOperationFailed(
						itemName: art.name,
						operation: .unmark,
						underlyingError: nil
					)
				}
			}
		} catch let error as RepositoryError {
			throw ServiceError.repositoryError(error)
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
		do {
			// Use the repository method which uses TownLinkable protocol
			return fossilRepository.getByTownId(townId: town.id)
		} catch {
			throw ServiceError.dataRetrievalFailed(
				dataType: "Fossil",
				filter: "town: \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets all bugs for a specific town
	/// - Parameter town: The town to get bugs for
	/// - Returns: Array of bugs linked to the town
	/// - Throws: ServiceError if the fetch operation fails
	func getBugsForTown(town: Town) throws -> [Bug] {
		do {
			// Use the repository method which uses TownLinkable protocol
			return bugRepository.getByTownId(townId: town.id)
		} catch {
			throw ServiceError.dataRetrievalFailed(
				dataType: "Bug",
				filter: "town: \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets all fish for a specific town
	/// - Parameter town: The town to get fish for
	/// - Returns: Array of fish linked to the town
	/// - Throws: ServiceError if the fetch operation fails
	func getFishForTown(town: Town) throws -> [Fish] {
		do {
			// Use the repository method which uses TownLinkable protocol
			return fishRepository.getByTownId(townId: town.id)
		} catch {
			throw ServiceError.dataRetrievalFailed(
				dataType: "Fish",
				filter: "town: \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets all art pieces for a specific town
	/// - Parameter town: The town to get art for
	/// - Returns: Array of art pieces linked to the town
	/// - Throws: ServiceError if the fetch operation fails
	func getArtForTown(town: Town) throws -> [Art] {
		do {
			// Use the repository method which uses TownLinkable protocol
			return artRepository.getByTownId(townId: town.id)
		} catch {
			throw ServiceError.dataRetrievalFailed(
				dataType: "Art",
				filter: "town: \(town.name)",
				underlyingError: error
			)
		}
	}
	
	// MARK: - Progress Tracking
	
	/// Gets donation progress for fossils in a specific town
	/// - Parameter town: The town to calculate progress for
	/// - Returns: Progress as a Double from 0.0 to 1.0
	/// - Throws: ServiceError if the fetch operation fails
	func getFossilProgressForTown(town: Town) throws -> Double {
		do {
			let fossils = try getFossilsForTown(town: town)
			guard !fossils.isEmpty else { return 0.0 }
			
			let donatedCount = fossils.filter { $0.isDonated }.count
			return Double(donatedCount) / Double(fossils.count)
		} catch {
			throw ServiceError.analyticsProcessingFailed(
				operationType: "Fossil Progress Calculation",
				reason: "Failed to retrieve fossils for town \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets donation progress for bugs in a specific town
	/// - Parameter town: The town to calculate progress for
	/// - Returns: Progress as a Double from 0.0 to 1.0
	/// - Throws: ServiceError if the fetch operation fails
	func getBugProgressForTown(town: Town) throws -> Double {
		do {
			let bugs = try getBugsForTown(town: town)
			guard !bugs.isEmpty else { return 0.0 }
			
			let donatedCount = bugs.filter { $0.isDonated }.count
			return Double(donatedCount) / Double(bugs.count)
		} catch {
			throw ServiceError.analyticsProcessingFailed(
				operationType: "Bug Progress Calculation",
				reason: "Failed to retrieve bugs for town \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets donation progress for fish in a specific town
	/// - Parameter town: The town to calculate progress for
	/// - Returns: Progress as a Double from 0.0 to 1.0
	/// - Throws: ServiceError if the fetch operation fails
	func getFishProgressForTown(town: Town) throws -> Double {
		do {
			let fish = try getFishForTown(town: town)
			guard !fish.isEmpty else { return 0.0 }
			
			let donatedCount = fish.filter { $0.isDonated }.count
			return Double(donatedCount) / Double(fish.count)
		} catch {
			throw ServiceError.analyticsProcessingFailed(
				operationType: "Fish Progress Calculation",
				reason: "Failed to retrieve fish for town \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets donation progress for art in a specific town
	/// - Parameter town: The town to calculate progress for
	/// - Returns: Progress as a Double from 0.0 to 1.0
	/// - Throws: ServiceError if the fetch operation fails
	func getArtProgressForTown(town: Town) throws -> Double {
		do {
			let artPieces = try getArtForTown(town: town)
			guard !artPieces.isEmpty else { return 0.0 }
			
			let donatedCount = artPieces.filter { $0.isDonated }.count
			return Double(donatedCount) / Double(artPieces.count)
		} catch {
			throw ServiceError.analyticsProcessingFailed(
				operationType: "Art Progress Calculation",
				reason: "Failed to retrieve art for town \(town.name)",
				underlyingError: error
			)
		}
	}
	
	/// Gets overall donation progress across all collectible types
	/// - Parameter town: The town to calculate progress for
	/// - Returns: Progress as a Double from 0.0 to 1.0
	/// - Throws: ServiceError if any fetch operation fails
	func getTotalProgressForTown(town: Town) throws -> Double {
		do {
			let fossilProgress = try getFossilProgressForTown(town: town)
			let bugProgress = try getBugProgressForTown(town: town)
			let fishProgress = try getFishProgressForTown(town: town)
			let artProgress = try getArtProgressForTown(town: town)
			
			let fossils = try getFossilsForTown(town: town)
			let bugs = try getBugsForTown(town: town)
			let fish = try getFishForTown(town: town)
			let artPieces = try getArtForTown(town: town)
			
			let fossilWeight = fossilProgress * Double(fossils.count)
			let bugWeight = bugProgress * Double(bugs.count)
			let fishWeight = fishProgress * Double(fish.count)
			let artWeight = artProgress * Double(artPieces.count)
			
			let totalItems = Double(fossils.count + bugs.count + fish.count + artPieces.count)
			guard totalItems > 0 else { return 0.0 }
			
			return (fossilWeight + bugWeight + fishWeight + artWeight) / totalItems
		} catch {
			throw ServiceError.analyticsProcessingFailed(
				operationType: "Total Progress Calculation",
				reason: "Failed to retrieve collection data for town \(town.name)",
				underlyingError: error
			)
		}
	}
}