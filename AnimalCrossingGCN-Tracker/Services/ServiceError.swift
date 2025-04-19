//
//  ServiceError.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/18/25.
//

import Foundation

/// Domain-specific errors for service operations
public enum ServiceError: Error {
    /// Thrown when an operation on a donation fails
    case donationOperationFailed(itemName: String, operation: DonationOperation, underlyingError: Error?)
    
    /// Thrown when a town-item linking operation fails
    case itemLinkingFailed(itemType: String, townName: String, operation: LinkOperation, underlyingError: Error?)
    
    /// Thrown when a data retrieval operation fails
    case dataRetrievalFailed(dataType: String, filter: String?, underlyingError: Error?)
    
    /// Thrown when an analytics operation fails
    case analyticsProcessingFailed(operationType: String, reason: String, underlyingError: Error?)
    
    /// Thrown when an export operation fails
    case exportFailed(format: String, reason: String, underlyingError: Error?)
    
    /// Thrown when a search operation fails
    case searchFailed(query: String, reason: String, underlyingError: Error?)
    
    /// Thrown when a repository operation fails and is passed through the service layer
    case repositoryError(RepositoryError)
    
    /// Thrown when a service operation depends on a town but none is selected
    case noTownSelected(operation: String)
    
    /// Thrown when validation fails for an operation
    case validationFailed(reason: String)
}

/// Types of donation operations
public enum DonationOperation: String {
    case mark = "Mark as Donated"
    case unmark = "Unmark as Donated"
    case update = "Update Status"
    case timestamp = "Set Donation Date"
}

/// Types of linking operations
public enum LinkOperation: String {
    case link = "Link"
    case unlink = "Unlink"
}

// MARK: - LocalizedError conformance

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .donationOperationFailed(let itemName, let operation, _):
            return "Failed to \(operation.rawValue.lowercased()) item '\(itemName)'"
            
        case .itemLinkingFailed(let itemType, let townName, let operation, _):
            return "Failed to \(operation.rawValue.lowercased()) \(itemType) with town '\(townName)'"
            
        case .dataRetrievalFailed(let dataType, let filter, _):
            if let filter = filter {
                return "Failed to retrieve \(dataType) data with filter '\(filter)'"
            }
            return "Failed to retrieve \(dataType) data"
            
        case .analyticsProcessingFailed(let operationType, let reason, _):
            return "Analytics processing failed: \(operationType) - \(reason)"
            
        case .exportFailed(let format, let reason, _):
            return "Export to \(format) failed: \(reason)"
            
        case .searchFailed(let query, let reason, _):
            return "Search for '\(query)' failed: \(reason)"
            
        case .repositoryError(let repoError):
            switch repoError {
            case .saveFailed(let entityName, _):
                return "Failed to save \(entityName)"
            case .deleteFailed(let entityName, _):
                return "Failed to delete \(entityName)"
            }
            
        case .noTownSelected(let operation):
            return "No town selected for operation: \(operation)"
            
        case .validationFailed(let reason):
            return "Validation failed: \(reason)"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .donationOperationFailed(_, _, let error):
            return error?.localizedDescription
            
        case .itemLinkingFailed(_, _, _, let error):
            return error?.localizedDescription
            
        case .dataRetrievalFailed(_, _, let error):
            return error?.localizedDescription
            
        case .analyticsProcessingFailed(_, _, let error):
            return error?.localizedDescription
            
        case .exportFailed(_, _, let error):
            return error?.localizedDescription
            
        case .searchFailed(_, _, let error):
            return error?.localizedDescription
            
        case .repositoryError(let repoError):
            switch repoError {
            case .saveFailed(_, let error), .deleteFailed(_, let error):
                return error.localizedDescription
            }
            
        case .noTownSelected(_):
            return "Please select or create a town first"
            
        case .validationFailed(let reason):
            return reason
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .donationOperationFailed:
            return "Try again or ensure the item exists"
            
        case .itemLinkingFailed:
            return "Verify both the item and town exist and try again"
            
        case .dataRetrievalFailed:
            return "Check your connection and try again"
            
        case .analyticsProcessingFailed:
            return "Try refreshing the data"
            
        case .exportFailed:
            return "Check file permissions and available storage"
            
        case .searchFailed:
            return "Try simplifying your search query"
            
        case .repositoryError:
            return "Try restarting the app"
            
        case .noTownSelected:
            return "Create or select a town to continue"
            
        case .validationFailed:
            return "Check your input and try again"
        }
    }
}

/// Utility to log service errors with appropriate detail level
public func logServiceError(_ error: ServiceError, file: String = #file, line: Int = #line, function: String = #function) {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    let logMessage = "[\(fileName):\(line) \(function)] \(error.errorDescription ?? "Unknown error")"
    
    // Detailed technical information for debug builds
    #if DEBUG
    var detailedInfo = ""
    
    switch error {
    case .repositoryError(let repoError):
        switch repoError {
        case .saveFailed(let entityName, let error), .deleteFailed(let entityName, let error):
            detailedInfo = "\nEntity: \(entityName)\nUnderlying error: \(error)"
        }
        
    case .donationOperationFailed(let itemName, let operation, let error):
        detailedInfo = "\nItem: \(itemName)\nOperation: \(operation)\nUnderlying error: \(error?.localizedDescription ?? "None")"
        
    case .itemLinkingFailed(let itemType, let townName, let operation, let error):
        detailedInfo = "\nItem type: \(itemType)\nTown: \(townName)\nOperation: \(operation)\nUnderlying error: \(error?.localizedDescription ?? "None")"
        
    case .analyticsProcessingFailed(let operationType, let reason, let error):
        detailedInfo = "\nOperation: \(operationType)\nReason: \(reason)\nUnderlying error: \(error?.localizedDescription ?? "None")"
        
    case .exportFailed(let format, let reason, let error):
        detailedInfo = "\nFormat: \(format)\nReason: \(reason)\nUnderlying error: \(error?.localizedDescription ?? "None")"
        
    default:
        detailedInfo = "\nFailure reason: \(error.failureReason ?? "Unknown")"
    }
    
    print("\(logMessage)\(detailedInfo)")
    #else
    print(logMessage)
    #endif
}