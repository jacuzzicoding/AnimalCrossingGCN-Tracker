//
//  ExportServiceProtocol.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/22/25.
//

import Foundation
import SwiftUI

/// Protocol defining the interface for export services
protocol ExportServiceProtocol {
    // MARK: - Export Operations
    
    /// Exports analytics data to CSV format
    /// - Parameters:
    ///   - data: The analytics data to export
    ///   - fileName: Optional custom file name
    /// - Returns: URL of the exported file
    /// - Throws: ServiceError if export fails
    func exportToCSV(data: AnalyticsExportData, fileName: String?) throws -> URL
    
    /// Exports a view to PNG format
    /// - Parameters:
    ///   - view: The SwiftUI view to export
    ///   - fileName: Optional custom file name
    /// - Returns: URL of the exported file
    /// - Throws: ServiceError if export fails
    func exportToPNG<T: View>(view: T, fileName: String?) throws -> URL
    
    /// Exports a view to PDF format
    /// - Parameters:
    ///   - view: The SwiftUI view to export
    ///   - fileName: Optional custom file name
    /// - Returns: URL of the exported file
    /// - Throws: ServiceError if export fails
    func exportToPDF<T: View>(view: T, fileName: String?) throws -> URL
    
    /// Copies data to the system clipboard
    /// - Parameter data: The data to copy
    /// - Throws: ServiceError if copy operation fails
    func copyToClipboard(data: Any) throws
    
    // MARK: - Platform-Specific Sharing
    
    #if os(iOS)
    /// Shares a file using the system share sheet (iOS)
    /// - Parameters:
    ///   - url: The file URL to share
    ///   - presentingViewController: The view controller to present the share sheet from
    func shareFile(url: URL, presentingViewController: UIViewController?)
    #elseif os(macOS)
    /// Shares a file using the system sharing service (macOS)
    /// - Parameter url: The file URL to share
    func shareFile(url: URL)
    #endif
}
