# Global Search Feature

This document provides information about the Global Search feature implemented in version 0.7.0-alpha of the Animal Crossing GCN Tracker app.

## Overview

Global Search allows users to search for items across all categories (Fossils, Bugs, Fish, and Art) simultaneously, rather than being limited to the currently selected category.

## How to Use

1. Tap or click the magnifying glass icon (🔍) in the toolbar to access the Global Search feature.
2. Enter your search term in the search bar.
3. Results will be grouped by category.
4. You can tap on any result to view its details.
5. Your recent searches are saved and can be accessed by tapping the clock icon (🕒) next to the search bar.

## Features

- **Cross-category search**: Search across all collectible types at once
- **Categorized results**: Results are organized by category for clarity
- **Real-time filtering**: Results update as you type
- **Search history**: Recent searches are saved for quick access
- **Game version awareness**: Results respect the current town's game version
- **Deep linking**: Tapping a result navigates to the appropriate detail view

## Technical Details

The Global Search implementation consists of the following components:

1. **GlobalSearchService**: A service class that handles searching across all repositories and manages search history.
2. **GlobalSearchView**: A SwiftUI view that provides the search interface and displays results.
3. **DataManager extensions**: Methods to integrate the search functionality with the rest of the app.

## Future Enhancements

Planned enhancements for the Global Search feature include:

- Advanced filtering options
- Search result sorting by various criteria
- Integration with system-level search
- Fuzzy matching for better results

## Troubleshooting

If you encounter issues with the Global Search feature:

- Ensure your database contains items (you should have at least some default items loaded)
- Verify that items are properly linked to the current town
- Try searching for different terms with various lengths
- If results are missing, check the town-item relationships

## Related Issues

This feature addresses the following issue:
- Issue #18: "Search Function Only Searches Currently Selected Category Vector"
