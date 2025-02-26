// Town.swift
import SwiftData
import Foundation

@Model
class Town {
    // Basic properties
    @Attribute(.unique) var id: UUID
    var name: String
    var playerName: String
    var gameVersion: String // Stores the ACGame.rawValue
    var creationDate: Date
    
    // Relationships to donated items
    @Relationship(deleteRule: .nullify, inverse: \Fossil.town)
    var fossils: [Fossil]?
    
    @Relationship(deleteRule: .nullify, inverse: \Bug.town)
    var bugs: [Bug]?
    
    @Relationship(deleteRule: .nullify, inverse: \Fish.town)
    var fish: [Fish]?
    
    @Relationship(deleteRule: .nullify, inverse: \Art.town)
    var art: [Art]?
    
    // Computed property for game enum
    var game: ACGame? {
        get {
            ACGame(rawValue: gameVersion)
        }
        set {
            if let newValue = newValue {
                gameVersion = newValue.rawValue
            }
        }
    }
    
    // Progress tracking computed properties
    var fossilProgress: Double {
        guard let fossils = fossils, !fossils.isEmpty else { return 0.0 }
        let donated = fossils.filter { $0.isDonated }.count
        return Double(donated) / Double(fossils.count)
    }
    
    var bugProgress: Double {
        guard let bugs = bugs, !bugs.isEmpty else { return 0.0 }
        let donated = bugs.filter { $0.isDonated }.count
        return Double(donated) / Double(bugs.count)
    }
    
    var fishProgress: Double {
        guard let fish = fish, !fish.isEmpty else { return 0.0 }
        let donated = fish.filter { $0.isDonated }.count
        return Double(donated) / Double(fish.count)
    }
    
    var artProgress: Double {
        guard let art = art, !art.isEmpty else { return 0.0 }
        let donated = art.filter { $0.isDonated }.count
        return Double(donated) / Double(art.count)
    }
    
    var totalProgress: Double {
        let fossilWeight = fossilProgress * (Double(fossils?.count ?? 0))
        let bugWeight = bugProgress * (Double(bugs?.count ?? 0))
        let fishWeight = fishProgress * (Double(fish?.count ?? 0))
        let artWeight = artProgress * (Double(art?.count ?? 0))
        
        let totalItems = Double(
            (fossils?.count ?? 0) +
            (bugs?.count ?? 0) +
            (fish?.count ?? 0) +
            (art?.count ?? 0)
        )
        
        guard totalItems > 0 else { return 0.0 }
        return (fossilWeight + bugWeight + fishWeight + artWeight) / totalItems
    }

    init(name: String, playerName: String = "Player", game: ACGame = .ACGCN) {
        self.id = UUID()
        self.name = name
        self.playerName = playerName
        self.gameVersion = game.rawValue
        self.creationDate = Date()
        self.fossils = []
        self.bugs = []
        self.fish = []
        self.art = []
    }
}
