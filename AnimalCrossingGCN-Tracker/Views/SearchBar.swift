//
//  SearchBar.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//

import SwiftUI

/// Enhanced search bar with global search toggle
struct SearchBar: View {
    @Binding var text: String
    @Binding var isGlobalSearch: Bool
    
    var body: some View {
        HStack {
            // Search field with magnifying glass
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search...", text: $text)
                    .foregroundColor(.primary)
                    .disableAutocorrection(false)
                if !text.isEmpty { 
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Global search toggle button with platform-specific styling
            #if os(iOS)
            Button(action: {
                isGlobalSearch.toggle()
            }) {
                HStack {
                    Image(systemName: isGlobalSearch ? "rectangle.and.text.magnifyingglass.rtl" : "rectangle.and.text.magnifyingglass")
                    Text(isGlobalSearch ? "Current" : "All")
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(isGlobalSearch ? Color.acLeafGreen.opacity(0.2) : Color.acBlathersPurple.opacity(0.2))
                .cornerRadius(8)
            }
            .help(isGlobalSearch ? "Search current category only" : "Search across all categories")
            #else
            Button(action: {
                isGlobalSearch.toggle()
            }) {
                HStack {
                    Image(systemName: isGlobalSearch ? "rectangle.and.text.magnifyingglass.rtl" : "rectangle.and.text.magnifyingglass")
                    Text(isGlobalSearch ? "Current Category" : "All Categories")
                        .font(.caption)
                }
            }
            .buttonStyle(LinkButtonStyle())
            .help(isGlobalSearch ? "Search only in the current category" : "Search across all categories")
            #endif
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBar(text: .constant(""), isGlobalSearch: .constant(false))
                .previewDisplayName("Local Search")
            
            SearchBar(text: .constant("fish"), isGlobalSearch: .constant(true))
                .previewDisplayName("Global Search")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
