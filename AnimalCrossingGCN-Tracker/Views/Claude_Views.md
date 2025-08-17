# Views Layer - AI Development Guide

## Overview
The Views layer contains all SwiftUI views, ViewModels, and UI components. Following MVVM pattern with a focus on modularity and reusability.

## Directory Structure
```
/Views/
├── /Analytics/         # Analytics and charts views
├── /Category/          # Category-specific views (Fish, Bug, etc.)
├── /Components/        # Reusable UI components
├── /Home/              # Home screen and related views
├── /Onboarding/        # First-launch experience
├── /Settings/          # App settings and preferences
├── /Shared/            # Shared views and modifiers
└── ContentView.swift   # Main navigation container
```

## Architecture Patterns

### MVVM Structure
```
View (SwiftUI)
  ↓ @StateObject / @ObservedObject
ViewModel (ObservableObject)
  ↓ Injected Dependencies
Services (Business Logic)
  ↓
Repositories (Data Access)
```

### View Composition
- **Small, focused components**: Each view has single responsibility
- **Composition over inheritance**: Build complex views from simple ones
- **Extracted subviews**: Improve compile times and readability
- **Reusable components**: Share common UI patterns

## Current State (May 22, 2025)

### Completed
- ✅ HomeView modularization with MVVM
- ✅ Component extraction pattern established
- ✅ Error handling UI components
- ✅ Analytics views with charts

### In Progress
- 🔄 ViewModels migration to dependency injection
- 🔄 Remaining views modularization
- 🔄 Accessibility improvements

### TODO
- ⏳ Donate Tab implementation
- ⏳ Settings screen redesign
- ⏳ iPad-optimized layouts
- ⏳ Dark mode refinements

## View Patterns

### Basic View Structure
```swift
struct SomeView: View {
    @StateObject private var viewModel: SomeViewModel
    @EnvironmentObject private var dataManager: DataManager
    
    var body: some View {
        // View implementation
    }
}
```

### ViewModel Pattern
```swift
@MainActor
class SomeViewModel: ObservableObject {
    @Published var data: [Item] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}
```

### Component Extraction
```swift
// Before: Large monolithic view
// After: Extracted components
struct ParentView: View {
    var body: some View {
        VStack {
            HeaderComponent()
            ContentSection()
            FooterComponent()
        }
    }
}
```

## AI Task Guidelines

### When Working with Views
1. **Extract complex views** into smaller components
2. **Use ViewModels** for business logic
3. **Handle all states**: loading, error, empty, success
4. **Consider accessibility** from the start
5. **Test on multiple screen sizes**

### Common Tasks
- **Add new screen**: Create View, ViewModel, and wire up navigation
- **Fix UI bug**: Check state management and data flow
- **Improve performance**: Extract views, use lazy loading
- **Add feature**: Start with UI, work backwards to services

### SwiftUI Best Practices
- Use `@StateObject` for owned ViewModels
- Use `@ObservedObject` for injected ViewModels
- Minimize `@State` in complex views
- Extract complex computed properties
- Use view modifiers for reusable styling

## Key Views

### ContentView
- Main navigation container
- Tab-based navigation
- Manages global state
- Entry point for app

### HomeView
- Dashboard overview
- Recently modularized
- Shows collection progress
- Quick access to features

### CategoryListView
- Displays items by category
- Filterable and searchable
- Donation management
- Progress tracking

### AnalyticsView
- Data visualizations
- Export functionality
- Seasonal insights
- Progress charts

## Component Library

### Reusable Components
- `ErrorBanner`: Consistent error display
- `ProgressBar`: Visual progress indicator
- `CategoryCard`: Category overview card
- `ActivityItem`: Timeline item display
- `LoadingView`: Loading states

### Custom Modifiers
- `.cardStyle()`: Consistent card appearance
- `.errorHandling()`: Error state management
- `.loadingOverlay()`: Loading indicators
- `.adaptive()`: Responsive layouts

## Recent Changes
- Modularized HomeView with MVVM
- Added ErrorState and ErrorBanner
- Created reusable UI components
- Improved compiler performance

## Next Steps
1. Complete ViewModels DI migration
2. Implement Donate Tab UI
3. Optimize remaining complex views
4. Add comprehensive preview providers

## Performance Tips
- Extract complex views to reduce compiler overhead
- Use `LazyVStack/LazyHStack` for lists
- Avoid unnecessary state updates
- Profile with Instruments
- Consider view caching for expensive renders

---

*Views Layer Guide - Last Updated: May 22, 2025*
