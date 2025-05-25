//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData

// Minimal ContentView for v0.7.0-alpha release
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Animal Crossing GCN Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Museum Collection Tracker")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Basic navigation buttons
                VStack(spacing: 16) {
                    Button("View Collections") {
                        // Navigate to collections
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Analytics") {
                        // Navigate to analytics
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Settings") {
                        // Navigate to settings
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Museum Tracker")
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
