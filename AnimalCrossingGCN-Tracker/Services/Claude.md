# Services Layer - AI Development Guide

## Overview
The Services layer contains business logic and orchestrates operations between repositories and the UI layer. All services follow protocol-based design for dependency injection.

## Directory Structure
```
/Services/
├── DataManager.swift           # Central coordination service
├── DonationService.swift       # Museum donation management
├── AnalyticsService.swift      # Analytics and statistics
├── ExportService.swift         # Export functionality
├── GlobalSearchService.swift   # Cross-category search
└── ServiceError.swift          # Service-specific errors
```

## Architecture Patterns

### Service Responsibilities
- **Business Logic**: Complex operations beyond simple CRUD
- **Cross-Repository Coordination**: Operations spanning multiple repositories
- **Data Transformation**: Converting between persistence and UI models
- **Error Handling**: Wrapping repository errors with context
- **Caching**: Performance optimization where needed

### Protocol-Based Design
All services implement protocols for:
- Dependency injection support
- Easy testing with mocks
- Clear interface contracts
- Loose coupling

Example:
```swift
protocol DonationServiceProtocol {
    func linkFossilToTown(fossil: Fossil, town: Town) throws
    // ... other methods
}

class DonationServiceImpl: DonationServiceProtocol {
    // Implementation
}
```

## Current State (May 22, 2025)

### Completed
- ✅ Service error types implemented
- ✅ DonationService with full error handling
- ✅ AnalyticsService with caching
- ✅ ExportService with platform-specific implementations
- ✅ Service protocols defined

### In Progress
- 🔄 Renaming services to *Impl pattern
- 🔄 Updating to use protocol-based dependencies
- 🔄 Integration with DependencyContainer

### TODO
- ⏳ GlobalSearchService protocol definition
- ⏳ Unit tests for all services
- ⏳ Performance profiling
- ⏳ Additional service methods as needed

## Service Patterns

### Error Handling
```swift
do {
    try someOperation()
} catch let error as RepositoryError {
    throw ServiceError.repositoryError(error)
} catch {
    throw ServiceError.specificError(context: relevantInfo)
}
```

### Dependency Injection
```swift
class SomeServiceImpl: SomeServiceProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
}
```

### Caching Pattern
```swift
private var cache: [String: CachedData] = [:]
private let cacheExpirationInterval: TimeInterval = 300 // 5 minutes
```

## AI Task Guidelines

### When Working on Services
1. **Always implement the protocol** first
2. **Wrap repository errors** appropriately
3. **Add caching** for expensive operations
4. **Document complex business logic**
5. **Consider thread safety** where needed

### Common Tasks
- **Add new service method**: Update protocol first, then implementation
- **Fix service bug**: Check error handling and repository usage
- **Optimize performance**: Look for caching opportunities
- **Add feature**: Consider which service owns the logic

### Testing Services
- Use mock repositories for unit tests
- Test error cases thoroughly
- Verify caching behavior
- Check thread safety if applicable

## Key Services

### DataManager
- Central coordination point
- Manages service lifecycle
- Provides unified interface to UI
- Being updated for DI support

### DonationService
- Manages item-town relationships
- Tracks donation status
- Calculates progress metrics
- Full error handling implemented

### AnalyticsService
- Processes donation statistics
- Generates timeline data
- Calculates seasonal metrics
- Includes smart caching

### ExportService
- Exports data to various formats
- Platform-specific implementations
- Handles file system operations
- Comprehensive error handling

## Integration Points
- **Repositories**: Services use repositories for data access
- **ViewModels**: ViewModels use services for business logic
- **DependencyContainer**: Services are registered and resolved here

## Recent Changes
- Added ServiceError types for better error handling
- Implemented comprehensive error handling across all services
- Created service protocols for dependency injection
- Added caching to AnalyticsService

## Next Steps
1. Complete service renaming to *Impl pattern
2. Update all services to use injected dependencies
3. Add comprehensive unit tests
4. Document any additional patterns discovered

---

*Service Layer Guide - Last Updated: May 22, 2025*
