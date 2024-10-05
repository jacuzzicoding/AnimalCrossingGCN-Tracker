//
//  Fossil.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
import Foundation
import SwiftData // or Core Data, depending on what you're using

struct Fossil: Identifiable {
    var id = UUID() // Unique identifier
    var name: String // Name of the fossil
    var part: String? // Optional part for multi-part fossils
    var isDonated: Bool = false // Tracks if the fossil is donated to the museum
}
