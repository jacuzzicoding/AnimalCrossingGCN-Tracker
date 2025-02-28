//
//  HomeTabBar.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//

import SwiftUI

/// Tab options for the home screen
enum HomeTab: Int, CaseIterable {
    case home
    case museum
    case donate
    case analytics
    case search
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .museum: return "Museum"
        case .donate: return "Donate"
        case .analytics: return "Analytics"
        case .search: return "Search"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .museum: return "building.columns.fill"
        case .donate: return "gift.fill"
        case .analytics: return "chart.pie.fill"
        case .search: return "magnifyingglass"
        }
    }
}

/// Bottom tab bar for main navigation
struct HomeTabBar: View {
    @Binding var selectedTab: HomeTab
    @EnvironmentObject var categoryManager: CategoryManager
    @Binding var isGlobalSearch: Bool
    
    var body: some View {
        HStack {
            ForEach(HomeTab.allCases, id: \.rawValue) { tab in
                Spacer()
                
                Button(action: {
                    handleTabSelection(tab)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                        
                        Text(tab.title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == tab ? .acLeafGreen : .gray)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
        )
    }
    
    private func handleTabSelection(_ tab: HomeTab) {
        // Special handling for different tabs
        switch tab {
        case .museum:
            // Reset to default category view
            categoryManager.selectedCategory = .fossils
            categoryManager.showingAnalytics = false
        case .analytics:
            // Show analytics view
            categoryManager.showingAnalytics = true
        case .search:
            // Activate global search
            isGlobalSearch = true
        default:
            break
        }
        
        // Update selected tab
        selectedTab = tab
    }
}

struct HomeTabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabBar(selectedTab: .constant(.home), isGlobalSearch: .constant(false))
            .environmentObject(CategoryManager())
            .previewLayout(.sizeThatFits)
    }
}
