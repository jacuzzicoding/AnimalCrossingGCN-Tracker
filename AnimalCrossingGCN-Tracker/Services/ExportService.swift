import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Supported export formats
enum ExportFormat {
    case csv
    case png
    case pdf
    case clipboard
    
    var fileExtension: String {
        switch self {
        case .csv: return "csv"
        case .png: return "png"
        case .pdf: return "pdf"
        case .clipboard: return ""
        }
    }
    
    var mimeType: String {
        switch self {
        case .csv: return "text/csv"
        case .png: return "image/png"
        case .pdf: return "application/pdf"
        case .clipboard: return "text/plain"
        }
    }
}

/// Data structure for analytics export
struct AnalyticsExportData {
    let donationActivity: [MonthlyDonationActivity]?
    let categoryCompletion: CategoryCompletionData?
    let seasonalData: SeasonalData?
    
    // Add any additional analytics data we want to export
}

/// Protocol defining export operations
protocol ExportService {
    /// Exports analytics data to CSV format
    /// - Parameters:
    ///   - data: The analytics data to export
    ///   - fileName: Optional file name (without extension)
    /// - Returns: URL to the exported file or nil if operation failed
    func exportToCSV(data: AnalyticsExportData, fileName: String?) -> URL?
    
    /// Exports a SwiftUI view to PNG format
    /// - Parameters:
    ///   - view: The SwiftUI view to export
    ///   - fileName: Optional file name (without extension)
    /// - Returns: URL to the exported file or nil if operation failed
    func exportToPNG<T: View>(view: T, fileName: String?) -> URL?
    
    /// Exports a SwiftUI view to PDF format
    /// - Parameters:
    ///   - view: The SwiftUI view to export
    ///   - fileName: Optional file name (without extension)
    /// - Returns: URL to the exported file or nil if operation failed
    func exportToPDF<T: View>(view: T, fileName: String?) -> URL?
    
    /// Copies data to clipboard
    /// - Parameter data: The data to copy
    /// - Returns: Boolean indicating success
    func copyToClipboard(data: Any) -> Bool
    
    /// Shares exported file using system share sheet
    /// - Parameters:
    ///   - url: URL of the file to share
    #if os(iOS)
    ///   - presentingViewController: The view controller presenting the share sheet
    func shareFile(url: URL, presentingViewController: UIViewController?)
    #elseif os(macOS)
    func shareFile(url: URL)
    #endif
}

/// Implementation of ExportService
class ExportServiceImpl: ExportService {
    
    private let fileManager = FileManager.default
    
    // MARK: - CSV Export
    
    func exportToCSV(data: AnalyticsExportData, fileName: String? = nil) -> URL? {
        var csvSections: [String] = []

        // 1. Generate CSV string from analytics data if available
        if let activity = data.donationActivity, !activity.isEmpty {
            csvSections.append(generateCSVFromDonationActivity(activity))
        }
        if let completion = data.categoryCompletion {
            csvSections.append(generateCSVFromCategoryCompletion(completion))
        }
        if let seasonal = data.seasonalData {
            csvSections.append(generateCSVFromSeasonalData(seasonal))
        }

        // Check if there's anything to export
        guard !csvSections.isEmpty else {
            print("No data available to export to CSV.")
            return nil
        }

        // Combine sections with a blank line separator
        let combinedCSVString = csvSections.joined(separator: "\n\n")

        // 2. Create temporary file URL
        let fileURL = createTemporaryFileURL(fileName: fileName, fileExtension: ExportFormat.csv.fileExtension)

        // 3. Save to temporary file
        do {
            try combinedCSVString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV data successfully written to: \(fileURL.path)")
            return fileURL
        } catch {
            print("Error writing CSV file: \(error)")
            return nil
        }
    }
    
    // MARK: - PNG Export
    
    func exportToPNG<T: View>(view: T, fileName: String? = nil) -> URL? {
        // TODO: Implement PNG export
        print("PNG Export not yet implemented.")
        return nil
    }
    
    // MARK: - PDF Export
    
    func exportToPDF<T: View>(view: T, fileName: String? = nil) -> URL? {
        // TODO: Implement PDF export
        print("PDF Export not yet implemented.")
        return nil
    }
    
    // MARK: - Clipboard
    
    func copyToClipboard(data: Any) -> Bool {
        // TODO: Implement clipboard functionality
        print("Copy to Clipboard not yet implemented.")
        return false
    }
    
    // MARK: - Sharing
    
    #if os(iOS)
    func shareFile(url: URL, presentingViewController: UIViewController?) {
        // TODO: Implement sharing functionality
        print("Share File not yet implemented.")
    }
    #elseif os(macOS)
    func shareFile(url: URL) {
        // TODO: Implement macOS sharing functionality
        print("macOS Share File not yet implemented.")
    }
    #endif
    
    // MARK: - Private Helper Methods
    
    /// Generates CSV string from monthly donation activity data
    private func generateCSVFromDonationActivity(_ activity: [MonthlyDonationActivity]) -> String {
        let header = "\"Month\",\"Year\",\"Total Donations\",\"Fossils Donated\",\"Bugs Donated\",\"Fish Donated\",\"Art Donated\""
        let calendar = Calendar.current // Get calendar instance

        // Sort chronologically by the date property
        let sortedActivity = activity.sorted { $0.month < $1.month }

        let rows = sortedActivity.map { item -> String in
            // Extract month and year from Date
            let monthComponent = calendar.component(.month, from: item.month)
            let yearComponent = calendar.component(.year, from: item.month)
            
            return formatCSVRow([
                "\(monthComponent)", // Use extracted month
                "\(yearComponent)", // Use extracted year
                "\(item.totalCount)", // Use totalCount as per actual struct
                "\(item.fossilCount)", // Use fossilCount
                "\(item.bugCount)", // Use bugCount
                "\(item.fishCount)", // Use fishCount
                "\(item.artCount)" // Use artCount
            ])
        }

        return ([header] + rows).joined(separator: "\n")
    }
    
    /// Generates CSV string from category completion data
    private func generateCSVFromCategoryCompletion(_ completion: CategoryCompletionData) -> String {
        let header = "\"Category\",\"Total Items\",\"Donated Items\",\"Completion Percentage\""
        var rows: [String] = []

        // Order: Fossils, Bugs, Fish, Art
        let categories = [
            ("Fossils", (total: completion.fossilCount, donated: completion.fossilDonated, progress: completion.fossilProgress)),
            ("Bugs", (total: completion.bugCount, donated: completion.bugDonated, progress: completion.bugProgress)),
            ("Fish", (total: completion.fishCount, donated: completion.fishDonated, progress: completion.fishProgress)),
            ("Art", (total: completion.artCount, donated: completion.artDonated, progress: completion.artProgress))
        ]

        for (name, data) in categories {
            let percentage = Int(data.progress * 100.0)
            rows.append(formatCSVRow([
                name,
                "\(data.total)",
                "\(data.donated)",
                "\(percentage)%" // Added % symbol for clarity
            ]))
        }

        return ([header] + rows).joined(separator: "\n")
    }
    
    /// Generates CSV string from seasonal data
    private func generateCSVFromSeasonalData(_ seasonal: SeasonalData) -> String {
        let header = "\"Season\",\"Available Items\",\"Donated Items\",\"Completion Percentage\""
        var rows: [String] = []

        // Group seasons into Spring, Summer, Fall, Winter
        let springMonths = ["Mar", "Apr", "May"]
        let summerMonths = ["Jun", "Jul", "Aug"]
        let fallMonths = ["Sep", "Oct", "Nov"]
        let winterMonths = ["Dec", "Jan", "Feb"]
        
        // Find seasonal completions for each month
        let springCompletions = seasonal.seasonalCompletion.filter { springMonths.contains($0.season) }
        let summerCompletions = seasonal.seasonalCompletion.filter { summerMonths.contains($0.season) }
        let fallCompletions = seasonal.seasonalCompletion.filter { fallMonths.contains($0.season) }
        let winterCompletions = seasonal.seasonalCompletion.filter { winterMonths.contains($0.season) }
        
        // Calculate seasonal totals
        let calculateTotals = { (completions: [SeasonalCompletion]) -> (available: Int, donated: Int, percentage: Int) in
            let available = completions.reduce(0) { $0 + $1.totalCount }
            let donated = completions.reduce(0) { $0 + $1.totalDonated }
            let percentage = available > 0 ? Int(Double(donated) / Double(available) * 100.0) : 0
            return (available, donated, percentage)
        }
        
        let springData = calculateTotals(springCompletions)
        let summerData = calculateTotals(summerCompletions)
        let fallData = calculateTotals(fallCompletions)
        let winterData = calculateTotals(winterCompletions)

        // Order: Spring, Summer, Fall, Winter
        let seasons = [
            ("Spring", springData),
            ("Summer", summerData),
            ("Fall", fallData),
            ("Winter", winterData)
        ]

        for (name, data) in seasons {
            rows.append(formatCSVRow([
                name,
                "\(data.available)",
                "\(data.donated)",
                "\(data.percentage)%" // Added % symbol for clarity
            ]))
        }

        return ([header] + rows).joined(separator: "\n")
    }
    
    /// Creates a temporary file URL with given name and extension
    private func createTemporaryFileURL(fileName: String?, fileExtension: String) -> URL {
        let directory = fileManager.temporaryDirectory
        // Use provided filename or generate a default one with timestamp
        let baseName = fileName ?? "analytics_export_\(Date().timeIntervalSince1970)"
        // Ensure filename is filesystem-friendly (basic example, might need more robust sanitization)
        let safeBaseName = baseName.replacingOccurrences(of: "[^a-zA-Z0-9_-]+", with: "_", options: .regularExpression)

        let url = directory.appendingPathComponent(safeBaseName).appendingPathExtension(fileExtension)
        return url
    }
    
    /// Formats an array of strings into a single CSV row, handling quoting.
    private func formatCSVRow(_ items: [String]) -> String {
        items.map { item in
            // Basic quoting: just enclose in double quotes.
            // More robust implementation would also double internal quotes.
            "\"\(item)\""
        }.joined(separator: ",")
    }
}
