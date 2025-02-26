//
//  TownDTO.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/26/25.
//

import Foundation

/// Data Transfer Object for Town model
struct TownDTO {
    var id: UUID
    var name: String
    var playerName: String
    var game: ACGame
    var creationDate: Date
    var fossilProgress: Double
    var bugProgress: Double
    var fishProgress: Double
    var artProgress: Double
    var totalProgress: Double
    
    /// Creates a basic DTO from a Town model
    /// - Parameter town: The town model to convert
    init(from town: Town) {
        self.id = town.id
        self.name = town.name
        self.playerName = town.playerName
        self.game = town.game ?? .ACGCN
        self.creationDate = town.creationDate
        self.fossilProgress = 0.0
        self.bugProgress = 0.0
        self.fishProgress = 0.0
        self.artProgress = 0.0
        self.totalProgress = 0.0
    }
    
    /// Creates a complete DTO with progress information
    /// - Parameters:
    ///   - town: The town model to convert
    ///   - fossilProgress: Progress for fossils
    ///   - bugProgress: Progress for bugs
    ///   - fishProgress: Progress for fish
    ///   - artProgress: Progress for art
    ///   - totalProgress: Overall progress
    init(from town: Town, fossilProgress: Double, bugProgress: Double, fishProgress: Double, artProgress: Double, totalProgress: Double) {
        self.id = town.id
        self.name = town.name
        self.playerName = town.playerName
        self.game = town.game ?? .ACGCN
        self.creationDate = town.creationDate
        self.fossilProgress = fossilProgress
        self.bugProgress = bugProgress
        self.fishProgress = fishProgress
        self.artProgress = artProgress
        self.totalProgress = totalProgress
    }
}
