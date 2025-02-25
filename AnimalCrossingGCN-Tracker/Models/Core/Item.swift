//
//  Item.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import Foundation
import SwiftUI
import SwiftData

// Base protocol for all collectible items
protocol CollectibleItem: Identifiable, Hashable {
    var id: UUID { get }
    var name: String { get }
    var isDonated: Bool { get set }
    var donationDate: Date? { get set } 
    var games: [ACGame] { get set }
}

// Explicitly extend all model classes to conform to CollectibleItem
extension Fossil: CollectibleItem {}
extension Bug: CollectibleItem {}
extension Fish: CollectibleItem {}
extension Art: CollectibleItem {}
