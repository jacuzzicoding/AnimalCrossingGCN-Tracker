//
//  ErrorState.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/21/25.
//
//  This file implements the ErrorState enum used for consistent error handling
//  across the app's UI components.

import SwiftUI

/// Error state representation used across the app
enum ErrorState: Equatable {
    case none
    case loading
    case dataLoadFailed(String)
    case operationFailed(String, recoverySuggestion: String? = nil)
    case networkError(String)
    case validationFailed(String)
    
    var message: String {
        switch self {
        case .none: return ""
        case .loading: return "Loading..."
        case .dataLoadFailed(let message): return message
        case .operationFailed(let message, _): return message
        case .networkError(let message): return message
        case .validationFailed(let message): return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .operationFailed(_, let suggestion): return suggestion
        case .networkError: return "Check your connection and try again"
        case .validationFailed: return "Please correct the error and try again"
        default: return nil
        }
    }
    
    var iconName: String {
        switch self {
        case .none: return ""
        case .loading: return "clock"
        case .dataLoadFailed: return "exclamationmark.triangle"
        case .operationFailed: return "exclamationmark.circle"
        case .networkError: return "wifi.slash"
        case .validationFailed: return "xmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .none, .loading: return .primary
        case .dataLoadFailed, .networkError: return .orange
        case .operationFailed: return .red
        case .validationFailed: return .red
        }
    }
}
