//
//  DonationTimestampableExt.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 12/18/24.
//

import Foundation
import SwiftUI

// Additional extensions for DonationTimestampable to support analytics and visualization
extension DonationTimestampable where Self: CollectibleItem {
    // Group-related helpers for analytics
    var donationDay: Int? {
        guard let donationDate else { return nil }
        return Calendar.current.component(.day, from: donationDate)
    }
    
    var donationWeek: Int? {
        guard let donationDate else { return nil }
        return Calendar.current.component(.weekOfYear, from: donationDate)
    }
    
    var donationQuarter: Int? {
        guard let donationMonth else { return nil }
        return (donationMonth - 1) / 3 + 1 // 1-4 for Q1-Q4
    }
    
    // Date comparison helpers
    func donatedBefore(date: Date) -> Bool {
        guard let donationDate = self.donationDate else { return false }
        return donationDate < date
    }
    
    func donatedAfter(date: Date) -> Bool {
        guard let donationDate = self.donationDate else { return false }
        return donationDate > date
    }
    
    func donatedBetween(startDate: Date, endDate: Date) -> Bool {
        guard let donationDate = self.donationDate else { return false }
        return donationDate >= startDate && donationDate <= endDate
    }
    
    // Time since donation
    var daysSinceDonation: Int? {
        guard let donationDate = self.donationDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: donationDate, to: Date())
        return components.day
    }
    
    // Formatting
    var relativeDonationDate: String? {
        guard let donationDate = self.donationDate else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: donationDate, relativeTo: Date())
    }
    
    // Color coding based on donation recency
    var donationColor: Color {
        guard isDonated, let days = daysSinceDonation else { return .gray }
        
        switch days {
        case 0...7: // Within last week
            return .green
        case 8...30: // Within last month
            return .blue
        case 31...90: // Within last quarter
            return .purple
        default: // Older donations
            return .orange
        }
    }
}
