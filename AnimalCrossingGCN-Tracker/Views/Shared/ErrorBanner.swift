//
//  ErrorBanner.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/21/25.
//
//  This file implements a reusable error banner component for displaying
//  errors inline within the app's UI.

import SwiftUI

/// A simple banner for displaying errors inline
struct ErrorBanner: View {
    let state: ErrorState
    var action: (() -> Void)? = nil
    
    var body: some View {
        if state != .none && state != .loading {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: state.iconName)
                    .foregroundColor(state.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(state.message)
                        .font(.callout)
                        .foregroundColor(.primary)
                    
                    if let suggestion = state.recoverySuggestion {
                        Text(suggestion)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let action = action {
                    Button(action: action) {
                        Text("Retry")
                            .font(.caption)
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            .padding()
            .background(state.color.opacity(0.1))
            .cornerRadius(8)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: state)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Error: \(state.message)")
        }
    }
}

struct ErrorBanner_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ErrorBanner(state: .dataLoadFailed("Failed to load data"))
            
            ErrorBanner(
                state: .operationFailed(
                    "Operation failed",
                    recoverySuggestion: "Try again later"
                ),
                action: {}
            )
            
            ErrorBanner(state: .networkError("Network connection lost"))
            
            ErrorBanner(state: .validationFailed("Invalid input"))
        }
        .padding()
    }
}
