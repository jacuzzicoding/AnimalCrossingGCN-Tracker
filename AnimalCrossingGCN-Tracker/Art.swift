//
//  Art.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/11/24.
//

struct Art: Identifiable {
    let id = UUID()
    let name: String
    let real: Bool?
    var donated: Bool
    var obtainedDate: Date?
}

extension Art {
    static func allArtPieces() -> [Art] {
        return [
            Art(name: "Academic Painting", real: nil, donated: false),
            Art(name: "Amazing Painting", real: nil, donated: false),
            // Add all art pieces from the game
        ]
    }
}
