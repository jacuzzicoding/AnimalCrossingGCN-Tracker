//
//  DonationTimestampable.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 12/18/24.
//

import Foundation //foundation is needed for Date, it is a built in library in swift

protocol DonationTimestampable {
	// Required properties that conforming types must implement
	var isDonated: Bool { get set }
	var donationDate: Date? { get set }
}

// Default implementations for all DonationTimestampable types
extension DonationTimestampable {
	// Donation management
	mutating func markDonated() {
		isDonated = true
		donationDate = Date()
		print("Donation date set to: \(donationDate?.description ?? "nil")")
	}
	
	mutating func unmarkDonated() {
		isDonated = false
		donationDate = nil
	}
	
	// Formatted date access
	var formattedDonationDate: String? {
		guard let donationDate else { return nil }
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter.string(from: donationDate)
	}
	
	// Donation analytics helpers
	var donationMonth: Int? {
		guard let donationDate else { return nil }
		return Calendar.current.component(.month, from: donationDate)
	}
	
	var donationYear: Int? {
		guard let donationDate else { return nil }
		return Calendar.current.component(.year, from: donationDate)
	}
}
