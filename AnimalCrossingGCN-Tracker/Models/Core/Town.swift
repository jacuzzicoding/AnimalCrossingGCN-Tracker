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
    
    // We'll handle relationships through the service layer
    // rather than explicit bidirectional references
    
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

    init(name: String, playerName: String = "Player", game: ACGame = .ACGCN) {
        self.id = UUID()
        self.name = name
        self.playerName = playerName
        self.gameVersion = game.rawValue
        self.creationDate = Date()
    }
}
