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
    var donationDate: Date? { get set } 
    var games: [ACGame] { get set }
}

// CollectibleItem should explicitly conform to DonationTimestampable
// but no automatic extension is needed since each model will directly implement
// both protocols with their own properties

// Remove the circular reference extension