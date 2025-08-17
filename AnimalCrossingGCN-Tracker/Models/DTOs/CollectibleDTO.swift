//
//  CollectibleDTO.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/26/25.
//

import Foundation

/// Base Data Transfer Object for all collectible items
protocol CollectibleDTO {
    var id: UUID { get }
    var name: String { get }
    var isDonated: Bool { get }
    var donationDate: Date? { get }
    var games: [ACGame] { get }
    var townId: UUID? { get }
    var formattedDonationDate: String? { get }
}

/// Data Transfer Object for Fossil model
struct FossilDTO: CollectibleDTO, Identifiable, Hashable {
    var id: UUID
    var name: String
    var part: String?
    var isDonated: Bool
    var donationDate: Date?
    var games: [ACGame]
    var townId: UUID?
    
    var formattedDonationDate: String? {
        guard let donationDate = donationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: donationDate)
    }
    
    /// Creates a DTO from a Fossil model
    /// - Parameter fossil: The fossil model to convert
    init(from fossil: Fossil) {
        self.id = fossil.id
        self.name = fossil.name
        self.part = fossil.part
        self.isDonated = fossil.isDonated
        self.donationDate = fossil.donationDate
        self.games = fossil.games
        self.townId = fossil.townId
    }
}

/// Data Transfer Object for Bug model
struct BugDTO: CollectibleDTO, Identifiable, Hashable {
    var id: UUID
    var name: String
    var season: String?
    var isDonated: Bool
    var donationDate: Date?
    var games: [ACGame]
    var townId: UUID?
    
    var formattedDonationDate: String? {
        guard let donationDate = donationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: donationDate)
    }
    
    /// Creates a DTO from a Bug model
    /// - Parameter bug: The bug model to convert
    init(from bug: Bug) {
        self.id = bug.id
        self.name = bug.name
        self.season = bug.season
        self.isDonated = bug.isDonated
        self.donationDate = bug.donationDate
        self.games = bug.games
        self.townId = bug.townId
    }
}

/// Data Transfer Object for Fish model
struct FishDTO: CollectibleDTO, Identifiable, Hashable {
    var id: UUID
    var name: String
    var season: String
    var location: String
    var isDonated: Bool
    var donationDate: Date?
    var games: [ACGame]
    var townId: UUID?
    
    var formattedDonationDate: String? {
        guard let donationDate = donationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: donationDate)
    }
    
    /// Creates a DTO from a Fish model
    /// - Parameter fish: The fish model to convert
    init(from fish: Fish) {
        self.id = fish.id
        self.name = fish.name
        self.season = fish.season
        self.location = fish.location
        self.isDonated = fish.isDonated
        self.donationDate = fish.donationDate
        self.games = fish.games
        self.townId = fish.townId
    }
}

/// Data Transfer Object for Art model
struct ArtDTO: CollectibleDTO, Identifiable, Hashable {
    var id: UUID
    var name: String
    var basedOn: String
    var isDonated: Bool
    var donationDate: Date?
    var games: [ACGame]
    var townId: UUID?
    
    var formattedDonationDate: String? {
        guard let donationDate = donationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: donationDate)
    }
    
    /// Creates a DTO from an Art model
    /// - Parameter art: The art model to convert
    init(from art: Art) {
        self.id = art.id
        self.name = art.name
        self.basedOn = art.basedOn
        self.isDonated = art.isDonated
        self.donationDate = art.donationDate
        self.games = art.games
        self.townId = art.townId
    }
}
