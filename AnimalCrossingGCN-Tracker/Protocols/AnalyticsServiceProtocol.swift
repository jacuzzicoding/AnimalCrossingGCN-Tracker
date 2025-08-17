//
//  AnalyticsServiceProtocol.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/22/25.
//

import Foundation

/// Protocol defining the interface for analytics services
protocol AnalyticsServiceProtocol {
    // MARK: - Cache Management
    
    /// Invalidates the analytics cache
    func invalidateCache()
    
    // MARK: - Timeline Analytics
    
    /// Get donation activity by month for a specific town
    /// - Parameters:
    ///   - town: The town to analyze
    ///   - startDate: Optional start date for filtering
    ///   - endDate: Optional end date for filtering
    /// - Returns: Array of monthly donation activity data
    /// - Throws: ServiceError if analytics processing fails
    func getDonationActivityByMonth(town: Town, startDate: Date?, endDate: Date?) throws -> [MonthlyDonationActivity]
    
    // MARK: - Category Analysis
    
    /// Get category completion data for a town
    /// - Parameter town: The town to analyze
    /// - Returns: Category completion data
    /// - Throws: ServiceError if analytics processing fails
    func getCategoryCompletionData(town: Town) throws -> CategoryCompletionData
    
    // MARK: - Seasonal Analysis
    
    /// Get seasonal data for bugs and fish
    /// - Parameter town: The town to analyze
    /// - Returns: Seasonal data
    /// - Throws: ServiceError if analytics processing fails
    func getSeasonalData(town: Town) throws -> SeasonalData
}
