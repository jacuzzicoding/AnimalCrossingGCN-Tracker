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

//CollectibleItem automatically conforms to DonationTimestampable
extension CollectibleItem {
    // This means any type that conforms to CollectibleItem
    // automatically gets DonationTimestampable for free
    var donationDate: Date? {
        get { self.donationDate }
        set { self.donationDate = newValue }
    }
}