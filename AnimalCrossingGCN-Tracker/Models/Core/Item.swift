//
//  Item.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import Foundation
import SwiftUI
import SwiftData

protocol CollectibleItem: Identifiable, Hashable {
    var id: UUID { get }
    var name: String { get }
    var isDonated: Bool { get set }
    var games: [ACGame] { get set }
}

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}