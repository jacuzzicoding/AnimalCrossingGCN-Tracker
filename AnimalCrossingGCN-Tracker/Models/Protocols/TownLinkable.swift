//
//  TownLinkable.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/16/25.
//

import Foundation

/// Protocol for models that can be linked to a Town via a townId.
protocol TownLinkable {
    /// The ID of the town this item is linked to (nil if not linked)
    var townId: UUID? { get set }
}
