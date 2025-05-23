### Recent Technical Improvements (May 22, 2025)
* **Dependency Injection Foundation**:
  * Created service protocols (DonationServiceProtocol, AnalyticsServiceProtocol, ExportServiceProtocol)
  * Implemented thread-safe DependencyContainer with SwiftUI integration
  * Prepared migration path for existing services
* **Enhanced Development System**:
  * Implemented Claude.md documentation pattern throughout codebase
  * Created `.claude/` directory for active development state
  * Established improved AI collaboration workflow
## 🤖 AI-Assisted Development

This project is optimized for AI-assisted development with multiple AI systems working collaboratively:

### Claude.md Documentation System
Every major directory contains a `Claude.md` file that provides:
- Module overview and architecture
- Current implementation status
- AI-specific guidance
- Common tasks and patterns

### Working Memory System
The `.claude/` directory maintains active development state:
- `WORKING_MEMORY.md` - Current session context
- `TASK_BOARD.md` - Kanban-style task tracking
- `DECISIONS.md` - Quick decision log
- `SYSTEM_IMPROVEMENTS.md` - Development system enhancements

### Multi-AI Collaboration
- **Claude 4**: Architecture, planning, documentation
- **Gemini 2.5 Pro**: Large refactoring, code analysis
- **GPT-4.1**: Implementation, testing, documentation
- **GPT-o3-mini**: Quick fixes, simple tasks

See `Copilot.md` for active cross-AI communication.

# AnimalCrossingGCN-Tracker

<div align="center">
  <img src="/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" alt="App Icon" width="128" height="128">
  
  **Version**: v0.7.0-alpha-preview-5  
  **Last Updated**: May 22, 2025  
  **Author**: Brock Jenkinson ([@jacuzzicoding](https://github.com/jacuzzicoding))
</div>

> **Latest Update**: Implementing comprehensive dependency injection system with protocol-based design. The project now includes Claude.md files throughout the codebase for enhanced AI-assisted development.

## 🚀 Quick Start for Developers

New to the project? Start here:
1. Read the root `Claude.md` file for project overview
2. Check `.claude/WORKING_MEMORY.md` for current session state
3. See `.claude/TASK_BOARD.md` for available tasks
4. Read module-specific `Claude.md` files as you work

## Project Overview

The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.7.0-alpha-preview-5 implements a comprehensive error handling architecture, introduces reusable UI components, and is currently undergoing a dependency injection implementation to improve testability and maintainability.

## Features

### Core Functionality
* Complete museum donation tracking:
  * Fossils (25 items)
  * Bugs (40 items)
  * Fish (40 items)
  * Art (13 pieces)
* Enhanced donation timestamp system
* Advanced town-based collection tracking
* Progress tracking by category and overall
* Modern floating category navigation
* Enhanced search functionality
* SwiftData integration for persistence

### Analytics Features
* Donation timeline visualization
* Category completion charts
* Seasonal availability analysis
* Progress tracking dashboard with accurate percentages
* Time period filtering options
* Interactive chart components
* Enhanced UI layout with improved component spacing

### Error Handling Architecture (NEW!)
* **Domain-specific error types**:
  * `RepositoryError` for data access/persistence errors
  * `ServiceError` for business logic/service layer errors
* **Standardized error propagation** with Swift's `throws` mechanism:
  * Repository methods throw `RepositoryError`
  * Service methods wrap repository errors and throw `ServiceError`
* **Consistent error handling patterns** across all application layers:
  * Repository Layer: Throws specific errors with context
  * Service Layer: Catches repository errors, adds context, and rethrows
  * View Layer: Catches and presents user-facing error messages
* **User-friendly error presentation**:
  * `ErrorState` enum for standardized error representation
  * `ErrorBanner` component for consistent visual display of errors
  * Proper recovery suggestions and actions

### Reusable UI Components (NEW!)
* **ProgressBar**: Customizable progress indicator for completion tracking
* **ActivityItem**: Consistent display of recent activity entries
* **CategoryIcon**: Standardized museum category representation
* **ErrorBanner**: Consistent visual representation for error states

### Technical Improvements
* Architectural enhancements:
  * ✅ Phase 1: Complete separation of models from views
  * ✅ Phase 2: Repository pattern implementation
  * ✅ Phase 3: Enhanced model relationships and service layer
  * ✅ Phase 4: Functional analytics with proper data visualization
  * ✅ Phase 5: Comprehensive error handling strategy
* Town-Item Linking System:
  * Ensures proper relationships between collectibles and towns
  * Uses efficient lookup sets for performance
  * Maintains game compatibility
  * Automatically runs when app starts or town changes
* Enhanced Services:
  * Properly handles and propagates errors with specific context
  * Implements consistent error types and patterns
  * Uses Swift's native error handling mechanisms
* UI improvements:
  * Extracted complex views into smaller components
  * Improved layout consistency with reusable components
  * Enhanced accessibility with proper error state descriptions
  * Fixed compiler performance issues in ContentView

### UI Components
* DetailMoreInfoView for donation timestamps
* Floating category switcher with custom icons
* Town-specific collection views
* Streamlined navigation system
* Refined search functionality
* Platform-specific optimizations
* Analytics dashboard with functional chart visualizations
* Interactive timeline and category charts
* **NEW** Reusable error presentation components
* **NEW** Progress and activity visualization components

## File Structure
```
AnimalCrossingGCN-Tracker/
├── .claude/                      # AI working memory and active state
│   ├── WORKING_MEMORY.md         # Current session context
│   ├── TASK_BOARD.md            # Active tasks and backlog
│   ├── DECISIONS.md             # Decision log
│   └── SYSTEM_IMPROVEMENTS.md   # Development system docs
├── Claude.md                     # Root AI guide
├── Copilot.md                   # Cross-AI communication
├── App/
│   ├── Claude.md                # App layer guide
│   └── AnimalCrossingGCN_TrackerApp.swift
├── Models/
│   ├── Claude.md                # Models guide
│   ├── Core/
│   │   ├── Item.swift
│   │   ├── Games.swift
│   │   ├── Town.swift
│   │   ├── Fossil.swift
│   │   ├── Bug.swift
│   │   ├── Fish.swift
│   │   └── Art.swift
│   ├── DTOs/
│   │   ├── CollectibleDTO.swift
│   │   └── TownDTO.swift
│   ├── Extensions/
│   │   └── Various model extensions
│   ├── Protocols/
│   │   ├── CollectibleItem.swift
│   │   ├── DonationTimestampable.swift
│   │   └── TownLinkable.swift
│   └── View Models/
│       └── Various view models
├── Views/
│   ├── Claude.md                # Views guide
│   ├── ContentView.swift
│   ├── ContentView+Analytics.swift
│   ├── MainListView.swift
│   ├── DetailMoreInfoView.swift
│   ├── EditTownView.swift
│   ├── FloatingCategorySwitcher.swift
│   ├── GlobalSearchView.swift
│   ├── Analytics/
│   │   └── AnalyticsDashboardView.swift
│   ├── DetailViews/
│   │   ├── FossilDetailView.swift
│   │   ├── BugDetailView.swift
│   │   ├── FishDetailView.swift
│   │   └── ArtDetailView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeTabBar.swift
│   │   ├── MainTabView.swift
│   │   └── Components/
│   │       ├── ActivityItem.swift
│   │       ├── CategoryIcon.swift
│   │       └── ProgressBar.swift
│   ├── Shared/
│   │   ├── ErrorState.swift
│   │   └── ErrorBanner.swift
│   └── Utilities/
│       └── ShareSheet.swift
├── Managers/
│   └── DataManager.swift
├── Repositories/
│   ├── Claude.md                # Repositories guide
│   ├── BaseRepository.swift
│   ├── RepositoryError.swift
│   ├── RepositoryProtocols.swift
│   ├── FossilRepository.swift
│   ├── BugRepository.swift
│   ├── FishRepository.swift
│   ├── ArtRepository.swift
│   └── TownRepository.swift
├── Services/
│   ├── Claude.md                # Services guide
│   ├── DonationService.swift
│   ├── AnalyticsService.swift
│   ├── ExportService.swift
│   ├── GlobalSearchService.swift
│   └── ServiceError.swift
├── Protocols/                   # DI protocols
│   ├── DonationServiceProtocol.swift
│   ├── AnalyticsServiceProtocol.swift
│   └── ExportServiceProtocol.swift
└── Utilities/
    ├── DependencyContainer.swift
    └── Various utility files
```

## Development Status

### Current Build Progress
* **v0.7.0-alpha-preview-6 (In Progress - May 22, 2025)**
  * 🚀 **Dependency Injection Implementation**
    * ✅ Created service protocols for all major services
    * ✅ Implemented thread-safe DependencyContainer
    * 🔄 Migrating services to protocol-based design
    * 🔄 Updating ViewModels to use injected dependencies
  * 🚀 **Enhanced Development System**
    * ✅ Implemented Claude.md documentation pattern
    * ✅ Created .claude/ working memory system
    * ✅ Established improved AI collaboration workflow
  * ⬜ Complete service migration to DI pattern
  * ⬜ Update app initialization with dependency configuration
  * ⬜ Add unit tests with mock implementations

* **v0.7.0-alpha-preview-5 (April 23, 2025)**
  * ✅ **Implemented Error Handling Architecture**
    * ✅ Added domain-specific error types
    * ✅ Implemented standardized error propagation
    * ✅ Created user-friendly error presentation components
    * ✅ Updated all services with error handling
  * ✅ **Added Reusable UI Components**
    * ✅ ErrorState enum for standardized error representation
    * ✅ ErrorBanner component for consistent error display
    * ✅ ProgressBar component for completion tracking
    * ✅ ActivityItem component for displaying recent activity
    * ✅ CategoryIcon component for consistent category visualization
  * ✅ **Service Layer Improvements**
    * ✅ Enhanced ExportService with proper error handling
    * ✅ Updated AnalyticsService with ServiceError pattern
    * ✅ Improved error context for better debugging
  * ✅ **UI Error Handling**
    * ✅ Fixed AnalyticsDashboardView with proper error handling
    * ✅ Updated HomeView with consistent error presentation
    * ✅ Fixed UI compatibility issues with analytics features
  * ⬜ Complete HomeView modularization
  * ⬜ Implement Donate Tab

* **v0.7.0-alpha-preview-3 (February 28, 2025)**
  * ✅ **Fixed Analytics Functionality**
    * ✅ Implemented town-item linking system
    * ✅ Rewrote analytics data processing
    * ✅ Fixed date handling for timeline charts
    * ✅ Corrected category progress calculations
    * ✅ Improved seasonal analysis

* **v0.7.0-alpha-preview-2 (February 27, 2025)**
  * ✅ Initial Analytics GUI implementation
  * ✅ UI layout enhancements

* **v0.7.0-alpha-preview (February 26, 2025)**
  * ✅ Completed Phases 1-3 of architectural improvements

### Breaking Changes
Version v0.7.0-alpha-preview introduced breaking changes that impact save compatibility:
1. Enhanced Town model with additional properties
2. ID-based relationship system instead of direct references
3. Modified data structure for all collectible items

### Next Development Phase
* v0.7.0-alpha full release plans:
  * HomeView modularization with reusable dashboard components
  * Donate tab implementation
  * Dependency injection approach implementation (ADR-003)
  * Global search functionality with cross-category search
  * Villager support with GameCube villagers database
  * Unit tests for services and repositories
  * Performance optimizations for analytics calculations

### Long-term Roadmap
* v0.7.x: Multi-game support beyond GameCube version
* v0.8.0: Custom hand-drawn icons and thumbnails
* v0.9.0: Enhanced iOS features (haptics, widgets)
* v1.0.0: Full-featured Animal Crossing companion app

## Platform Support

### iOS/iPadOS
* Full feature support
* Optimized floating UI elements
* Native platform interactions
* Responsive layouts for all screen sizes
* Functional SwiftCharts visualizations for analytics

### macOS
* Complete feature parity with iOS
* Enhanced keyboard navigation
* Native menu bar integration
* Platform-specific UI refinements
* Optimized chart layouts for desktop use

## Technical Requirements
* Xcode 15.5+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions
* Swift Charts for analytics visualizations

## Known Issues
* HomeView modularization is still in progress
* Donate Tab implementation is planned for a future release
* Dependency injection approach (ADR-003) is not yet implemented
* Minor UI adjustments may be needed on smaller devices

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License