# Models Layer - AI Development Guide

## Overview
The Models layer contains SwiftData model definitions, protocols, and domain objects. This is the foundation of the app's data structure.

## Directory Structure
```
/Models/
├── /Protocols/
│   ├── CollectibleItem.swift      # Core protocol for all collectibles
│   ├── DonationTimestampable.swift # Protocol for donation tracking
│   └── TownLinkable.swift          # Protocol for town relationships
├── Art.swift                       # Art piece model
├── Bug.swift                       # Bug model
├── Fish.swift                      # Fish model
├── Fossil.swift                    # Fossil model
├── Town.swift                      # Town model
└── ModelContainer.swift            # SwiftData configuration
```

## Architecture Patterns

### SwiftData Models
All models:
- Use `@Model` macro for persistence
- Implement relevant protocols
- Include computed properties for UI
- Handle optional relationships safely

### Protocol Hierarchy
```
CollectibleItem (base protocol)
    ├── DonationTimestampable
    └── TownLinkable
```

### Model Relationships
- **Town** ← → **Collectibles** (via townId)
- All relationships use UUID-based linking
- No direct object references (SwiftData best practice)

## Current State (May 22, 2025)

### Completed
- ✅ All base models implemented
- ✅ Protocol hierarchy established
- ✅ TownLinkable protocol for standardization
- ✅ Comprehensive model properties

### In Progress
- 🔄 Optimizing model performance
- 🔄 Adding validation rules

### TODO
- ⏳ Model versioning strategy
- ⏳ Migration handlers
- ⏳ Additional computed properties
- ⏳ Performance indexing

## Model Patterns

### Basic Model Structure
```swift
@Model
final class SomeItem: CollectibleItem, DonationTimestampable, TownLinkable {
    var id: UUID
    var name: String
    var isDonated: Bool
    var donationDate: Date?
    var townId: UUID?
    
    // Computed properties
    var displayName: String { 
        // Formatting logic
    }
}
```

### Protocol Conformance
```swift
// CollectibleItem
var id: UUID { get }
var name: String { get set }
var isDonated: Bool { get set }

// DonationTimestampable  
var donationDate: Date? { get set }

// TownLinkable
var townId: UUID? { get set }
```

## AI Task Guidelines

### When Working with Models
1. **Never modify** `@Model` properties without testing migration
2. **Always implement** required protocols
3. **Use computed properties** for UI formatting
4. **Handle optionals** safely
5. **Document** any special behaviors

### Common Tasks
- **Add model property**: Consider migration impact
- **Add computed property**: No migration needed
- **Fix model bug**: Check SwiftData queries
- **Optimize performance**: Look at indexes and fetch patterns

### Testing Models
- Test CRUD operations
- Verify relationship integrity
- Check computed properties
- Test edge cases with optionals

## Key Models

### Town
- Central entity for organizing collections
- Has many collectibles (via townId)
- Supports multiple save files
- Includes metadata (mayor, creation date)

### Fossil
- 25 distinct fossils in GameCube version
- Grouped by dinosaur parts
- Includes selling price
- Links to specific town

### Bug
- Seasonal availability
- Time-based appearance
- Location information
- Rarity indicators

### Fish
- Complex seasonality
- Multiple location types
- Size categories
- Weather dependencies

### Art
- Based on real artworks
- Artist information
- Single instance per town
- High value items

## SwiftData Considerations

### Performance
- Use lazy loading for relationships
- Batch operations when possible
- Index frequently queried properties
- Minimize model complexity

### Migration
- Plan property additions carefully
- Test with existing data
- Provide default values
- Document migration steps

## Recent Changes
- Added TownLinkable protocol
- Standardized donation tracking
- Improved model documentation
- Optimized fetch patterns

## Next Steps
1. Add model validation rules
2. Implement versioning strategy
3. Optimize query performance
4. Document migration procedures

---

*Models Layer Guide - Last Updated: May 22, 2025*
