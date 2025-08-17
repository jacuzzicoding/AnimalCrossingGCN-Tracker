# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Animal Crossing GCN Tracker is a SwiftUI application for tracking museum donations in Animal Crossing GameCube. Built using modern Swift patterns with SwiftData for persistence, following a layered architecture with repository pattern, service layer, and dependency injection.

## Build and Development Commands

### Building the Project
```bash
# Build the project (requires Xcode)
xcodebuild -scheme "AnimalCrossingGCN-Tracker" -destination "platform=iOS Simulator,name=iPhone 15" build

# Build for macOS
xcodebuild -scheme "AnimalCrossingGCN-Tracker" -destination "platform=macOS" build

# Clean build
xcodebuild clean
```

### Running Tests
```bash
# Run unit tests
xcodebuild test -scheme "AnimalCrossingGCN-Tracker" -destination "platform=iOS Simulator,name=iPhone 15"

# Run UI tests  
xcodebuild test -scheme "AnimalCrossingGCN-Tracker" -destination "platform=iOS Simulator,name=iPhone 15" -only-testing:AnimalCrossingGCN-TrackerUITests
```

### Xcode Development
- Open `AnimalCrossingGCN-Tracker.xcodeproj` in Xcode
- Primary target: `AnimalCrossingGCN-Tracker`
- Supports iOS 17.0+, macOS 14.0+
- Uses SwiftUI and SwiftData frameworks

## Architecture

### Layered Architecture
The codebase follows a clean layered architecture:

```
App Layer           → AnimalCrossingGCN_TrackerApp.swift, AppDependencies.swift  
View Layer          → SwiftUI Views + ViewModels (MVVM)
Service Layer       → Business logic (DonationService, AnalyticsService, etc.)
Repository Layer    → Data access abstraction  
Model Layer         → SwiftData models + Protocols
```

### Key Architectural Patterns
- **Repository Pattern**: Data access abstraction in `/Repositories/`
- **Service Layer**: Business logic separation in `/Services/` 
- **MVVM**: View-ViewModel separation throughout `/Views/`
- **Dependency Injection**: Protocol-based DI with `DependencyContainer`
- **Error Handling**: Domain-specific errors (`RepositoryError`, `ServiceError`)

### Dependency Injection System
- **Container**: `DependencyContainer` in `/Utilities/`
- **Configuration**: `AppDependencies.configure()` in `/App/`
- **Protocols**: Service protocols in `/Protocols/`
- **Implementation**: Services end with `Impl` suffix (e.g., `DonationServiceImpl`)

## Key Files and Directories

### Core Application
- `/App/AnimalCrossingGCN_TrackerApp.swift` - Main app entry point with SwiftData setup
- `/App/AppDependencies.swift` - Dependency injection configuration
- `/Utilities/DependencyContainer.swift` - DI container implementation

### Data Layer  
- `/Models/Core/` - SwiftData models (Item, Town, Bug, Fish, Fossil, Art)
- `/Models/Protocols/` - Core protocols (DonationTimestampable, TownLinkable)
- `/Repositories/` - Data access layer with error handling
- `/Services/` - Business logic layer

### UI Layer
- `/Views/ContentView.swift` - Main content view with tab navigation
- `/Views/Home/` - Dashboard and home screen components  
- `/Views/Analytics/` - Analytics dashboard and charts
- `/Views/Shared/` - Reusable UI components (ErrorBanner, etc.)

### Documentation System
- `/.claude/` - Active development state (working memory, tasks, decisions)
- Module-specific `Claude.md` files throughout codebase
- `AI_SYSTEM_INSTRUCTIONS.md` - Comprehensive AI development guide

## SwiftData Models

### Core Models
- **Item**: Base collectible item protocol implementation
- **Town**: Game town with collectible relationships  
- **Bug/Fish/Fossil/Art**: Specific collectible types with museum data

### Relationships
- ID-based relationships instead of direct object references
- Town-Item linking system for proper game compatibility
- Donation timestamps through `DonationTimestampable` protocol

## Development Guidelines

### Code Patterns to Follow
- Use protocol-oriented design throughout
- Follow existing error handling patterns (`throws` with domain-specific errors)
- Extract UI components following the pattern in `/Views/Shared/`
- Use dependency injection for testability
- Maintain SwiftData model consistency

### Error Handling
- Repository layer throws `RepositoryError` 
- Service layer catches and wraps as `ServiceError`
- Views handle errors with `ErrorBanner` component
- Always provide user-friendly error messages

### UI Development
- Follow SwiftUI best practices with component extraction
- Use `@EnvironmentObject` for dependency injection
- Maintain iOS/macOS cross-platform compatibility
- Extract complex views into smaller, reusable components

## Current Development Status

**Version**: v0.7.0-alpha-preview-5  
**Branch**: working-branch

### Recently Completed
- ✅ Dependency injection system implementation
- ✅ Repository pattern with error handling  
- ✅ Service layer architecture
- ✅ UI component modularization
- ✅ SwiftData model relationships

### Active Development
- Verification of app compilation and functionality
- Unit testing infrastructure planning
- Performance optimization preparation

### Next Milestones  
- Unit testing framework implementation
- Donate Tab feature
- App Store preparation

## Working with AI Development System

This project uses an AI-assisted development system:

1. **Check Current State**: Read `.claude/WORKING_MEMORY.md` for active session context
2. **Find Tasks**: See `.claude/TASK_BOARD.md` for current priorities  
3. **Module Context**: Read `Claude.md` files in specific directories
4. **Make Decisions**: Document in `.claude/DECISIONS.md`

The codebase is optimized for AI-assisted development with comprehensive documentation and clear architectural patterns.
- This is a github repository, please follow git best practices via the terminal.
- Project notes are stored in an Obsidian vault located: /Users/brockjenkinson/Local/Obsidian/SwiftCoding/AnimalCrossingGCN-Tracker