# Repositories Layer - AI Development Guide

## Overview
The Repositories layer provides data access abstraction using the repository pattern. All repositories work with SwiftData models and provide a consistent interface for CRUD operations.

## Directory Structure
```
/Repositories/
├── /Protocols/
│   └── Repository.swift           # Base repository protocol
├── BaseRepository.swift           # Generic implementation
├── FossilRepository.swift         # Fossil-specific queries
├── BugRepository.swift            # Bug-specific queries
├── FishRepository.swift           # Fish-specific queries
├── ArtRepository.swift            # Art-specific queries
├── TownRepository.swift           # Town management
└── RepositoryError.swift          # Repository-specific errors
```

## Architecture Patterns

### Repository Pattern Benefits
- **Abstraction**: Hides SwiftData implementation details
- **Testability**: Easy to mock for unit tests
- **Consistency**: Uniform interface across all models
- **Flexibility**: Can change persistence layer if needed

### Generic Base Repository
```swift
class BaseRepository<T: PersistentModel>: Repository {
    typealias ModelType = T
    protected let modelContext: ModelContext
    
    // Common CRUD operations
    func getAll() -> [T]
    func getById(id: UUID) -> T?
    func save(_ item: T) throws
    func delete(_ item: T) throws
}
```

### Specialized Repositories
Each model has its own repository with:
- Model-specific queries
- Optimized fetch requests
- Business-specific methods
- Proper error handling

## Current State (May 22, 2025)

### Completed
- ✅ Base repository with generics
- ✅ All model repositories implemented
- ✅ TownLinkable protocol support
- ✅ Comprehensive error handling
- ✅ Repository protocols defined

### In Progress
- 🔄 Performance optimization
- 🔄 Additional query methods

### TODO
- ⏳ Batch operations support
- ⏳ Query result caching
- ⏳ Migration helpers
- ⏳ Index optimization

## Repository Patterns

### Basic Repository Structure
```swift
class SomeRepository: BaseRepository<SomeModel> {
    // Leverage base implementation
    
    // Add specific queries
    func findByProperty(_ value: String) -> [SomeModel] {
        let descriptor = FetchDescriptor<SomeModel>(
            predicate: #Predicate { $0.property == value }
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
```

### Error Handling
```swift
func save(_ item: T) throws {
    do {
        modelContext.insert(item)
        try modelContext.save()
    } catch {
        throw RepositoryError.saveFailed(
            modelType: String(describing: T.self),
            underlyingError: error
        )
    }
}
```

### Town Linkable Pattern
```swift
func getByTownId(townId: UUID) -> [T] where T: TownLinkable {
    let descriptor = FetchDescriptor<T>(
        predicate: #Predicate { $0.townId == townId }
    )
    return (try? modelContext.fetch(descriptor)) ?? []
}
```

## AI Task Guidelines

### When Working with Repositories
1. **Use base repository** methods when possible
2. **Handle errors** appropriately with context
3. **Optimize queries** for performance
4. **Document** complex predicates
5. **Test** edge cases

### Common Tasks
- **Add query method**: Follow existing patterns
- **Fix performance issue**: Check fetch descriptors and predicates
- **Add batch operation**: Consider transaction boundaries
- **Debug data issue**: Check SwiftData constraints

### SwiftData Best Practices
- Use `FetchDescriptor` for queries
- Batch saves when possible
- Handle model constraints
- Use proper predicates
- Consider fetch limits

## Key Repositories

### TownRepository
- Manages town entities
- Ensures default town exists
- Handles town switching
- Maintains current town state

### FossilRepository
- Queries by fossil parts
- Groups by dinosaur
- Optimized for display

### BugRepository
- Seasonal filtering
- Time-based queries
- Location grouping

### FishRepository
- Complex seasonal logic
- Multiple location types
- Size-based queries

### ArtRepository
- Unique items only
- Artist-based queries
- High-value tracking

## Query Optimization

### Performance Tips
```swift
// Use fetch limits
descriptor.fetchLimit = 50

// Sort at database level
descriptor.sortBy = [SortDescriptor(\.name)]

// Use compound predicates efficiently
#Predicate<Model> { item in
    item.property1 == value1 && 
    item.property2 == value2
}
```

### Common Patterns
- **Pagination**: Use fetchLimit and fetchOffset
- **Sorting**: Apply at fetch level, not in memory
- **Filtering**: Use predicates, not array filters
- **Relationships**: Fetch related data efficiently

## Error Handling

### Repository Errors
```swift
enum RepositoryError: LocalizedError {
    case saveFailed(modelType: String, underlyingError: Error)
    case deleteFailed(modelType: String, underlyingError: Error)
    case fetchFailed(modelType: String, underlyingError: Error)
    case modelNotFound(modelType: String, id: UUID)
}
```

## Recent Changes
- Added comprehensive error handling
- Implemented TownLinkable support
- Optimized common queries
- Added delete functionality

## Next Steps
1. Add batch operation support
2. Implement query result caching
3. Create performance benchmarks
4. Add migration utilities

---

*Repositories Layer Guide - Last Updated: May 22, 2025*
