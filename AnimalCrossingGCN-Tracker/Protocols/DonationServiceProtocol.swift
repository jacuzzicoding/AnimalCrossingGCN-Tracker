//
//  DonationServiceProtocol.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/22/25.
//

import Foundation
import SwiftData

/// Protocol defining the interface for donation management services
protocol DonationServiceProtocol {
    // MARK: - Linking Items to Town
    
    /// Links a fossil to a specific town
    /// - Parameters:
    ///   - fossil: The fossil to link
    ///   - town: The town to link the fossil to
    /// - Throws: ServiceError if the linking operation fails
    func linkFossilToTown(fossil: Fossil, town: Town) throws
    
    /// Links a bug to a specific town
    /// - Parameters:
    ///   - bug: The bug to link
    ///   - town: The town to link the bug to
    /// - Throws: ServiceError if the linking operation fails
    func linkBugToTown(bug: Bug, town: Town) throws
    
    /// Links a fish to a specific town
    /// - Parameters:
    ///   - fish: The fish to link
    ///   - town: The town to link the fish to
    /// - Throws: ServiceError if the linking operation fails
    func linkFishToTown(fish: Fish, town: Town) throws
    
    /// Links an art piece to a specific town
    /// - Parameters:
    ///   - art: The art piece to link
    ///   - town: The town to link the art to
    /// - Throws: ServiceError if the linking operation fails
    func linkArtToTown(art: Art, town: Town) throws
    
    // MARK: - Unlinking Items from Town
    
    /// Unlinks a fossil from any town
    /// - Parameter fossil: The fossil to unlink
    /// - Throws: ServiceError if the unlinking operation fails
    func unlinkFossilFromTown(fossil: Fossil) throws
    
    /// Unlinks a bug from any town
    /// - Parameter bug: The bug to unlink
    /// - Throws: ServiceError if the unlinking operation fails
    func unlinkBugFromTown(bug: Bug) throws
    
    /// Unlinks a fish from any town
    /// - Parameter fish: The fish to unlink
    /// - Throws: ServiceError if the unlinking operation fails
    func unlinkFishFromTown(fish: Fish) throws
    
    /// Unlinks an art piece from any town
    /// - Parameter art: The art piece to unlink
    /// - Throws: ServiceError if the unlinking operation fails
    func unlinkArtFromTown(art: Art) throws
    
    // MARK: - Donation Management
    
    /// Marks an item as donated with current timestamp
    /// - Parameter item: The item to mark as donated
    /// - Throws: ServiceError if the operation fails
    func markItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T) throws
    
    /// Marks an item as donated with a specific timestamp
    /// - Parameters:
    ///   - item: The item to mark as donated
    ///   - date: The date to set as the donation date
    /// - Throws: ServiceError if the operation fails
    func markItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T, withDate date: Date) throws
    
    /// Unmarks an item as donated and removes the timestamp
    /// - Parameter item: The item to unmark as donated
    /// - Throws: ServiceError if the operation fails
    func unmarkItemAsDonated<T: CollectibleItem & PersistentModel>(_ item: T) throws
    
    // MARK: - Fetching Items by Town
    
    /// Gets all fossils for a specific town
    /// - Parameter town: The town to get fossils for
    /// - Returns: Array of fossils linked to the town
    /// - Throws: ServiceError if the fetch operation fails
    func getFossilsForTown(town: Town) throws -> [Fossil]
    
    /// Gets all bugs for a specific town
    /// - Parameter town: The town to get bugs for
    /// - Returns: Array of bugs linked to the town
    /// - Throws: ServiceError if the fetch operation fails
    func getBugsForTown(town: Town) throws -> [Bug]
    
    /// Gets all fish for a specific town
    /// - Parameter town: The town to get fish for
    /// - Returns: Array of fish linked to the town
    /// - Throws: ServiceError if the fetch operation fails
    func getFishForTown(town: Town) throws -> [Fish]
    
    /// Gets all art pieces for a specific town
    /// - Parameter town: The town to get art for
    /// - Returns: Array of art pieces linked to the town
    /// - Throws: ServiceError if the fetch operation fails
    func getArtForTown(town: Town) throws -> [Art]
    
    // MARK: - Progress Tracking
    
    /// Gets donation progress for fossils in a specific town
    /// - Parameter town: The town to calculate progress for
    /// - Returns: Progress as a Double from 0.0 to 1.0
    /// - Throws: ServiceError if the calculation fails
    func getFossilProgressForTown(town: Town) throws -> Double
    
    /// Gets donation progress for bugs in a specific town
    /// - Parameter town: The town to calculate progress for
    /// - Returns: Progress as a Double from 0.0 to 1.0
    /// - Throws: ServiceError if the calculation fails
    func getBugProgressForTown(town: Town) throws -> Double
    
    /// Gets donation progress for fish in a specific town
    /// - Parameter town: The town to calculate progress for
    /// - Returns: Progress as a Double from 0.0 to 1.0
    /// - Throws: ServiceError if the calculation fails
    func getFishProgressForTown(town: Town) throws -> Double
    
    /// Gets donation progress for art in a specific town
    /// - Parameter town: The town to calculate progress for
    /// - Returns: Progress as a Double from 0.0 to 1.0
    /// - Throws: ServiceError if the calculation fails
    func getArtProgressForTown(town: Town) throws -> Double
    
    /// Gets overall donation progress across all collectible types
    /// - Parameter town: The town to calculate progress for
    /// - Returns: Progress as a Double from 0.0 to 1.0
    /// - Throws: ServiceError if any calculation fails
    func getTotalProgressForTown(town: Town) throws -> Double
}
