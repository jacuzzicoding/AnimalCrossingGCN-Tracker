# Working Memory - Active Development Session

## Current Session
- **Date**: May 23, 2025
- **Active Branch**: `code-cleanup`
- **Version**: v0.7.0-alpha-preview-5 (working toward v0.7.0-alpha)
- **Last Commit**: Dependency injection foundation
- **Session Goal**: Complete v0.7.0-alpha release

## Session Context

### What We're Building
Implementing comprehensive dependency injection system across the app to improve testability and reduce coupling.

### Progress Today
1. ✅ Created service protocols (DonationServiceProtocol, AnalyticsServiceProtocol, ExportServiceProtocol)
2. ✅ Implemented DependencyContainer with thread safety
3. ✅ Set up new Claude.md documentation system
4. 🔄 Delegated service renaming to Copilot/GPT-4.1
5. ✅ Updated AI system instructions to reflect hybrid documentation approach

### Active State
- **Services**: Need renaming from Service → ServiceImpl
- **DataManager**: Needs update to use protocol types
- **App Initialization**: Needs dependency configuration
- **ViewModels**: Need migration to injected dependencies

### Known Issues
- GlobalSearchService protocol not yet defined
- Some ViewModels still directly instantiate services
- Test infrastructure needs mock implementations

## Key Decisions Made

### Architecture
- Use protocol-based dependency injection
- Maintain backward compatibility during transition
- Thread-safe container implementation
- SwiftUI environment for dependency distribution

### Documentation
- Implement Claude.md files in codebase
- Maintain Obsidian vault for permanent docs
- Use .claude/ directory for working state

## Next Immediate Tasks
1. Monitor Copilot's implementation of service renaming
2. Review and test the dependency injection changes
3. Update HomeViewModel to use injected services
4. Create mock implementations for testing

## Important Context

### File Locations
- Protocols: `/AnimalCrossingGCN-Tracker/Protocols/`
- Container: `/AnimalCrossingGCN-Tracker/Utilities/DependencyContainer.swift`
- Services: `/AnimalCrossingGCN-Tracker/Services/`
- Task delegation: `/Copilot.md`

### Dependencies Flow
```
DependencyContainer
    ├── Repositories (Singletons)
    ├── Services (Factories with dependencies)
    └── DataManager (Composed of services)
```

### Testing Strategy
- Create protocol-based mocks
- Use test-specific containers
- Verify dependency resolution
- Test service interactions

## Communication Channels
- **Copilot.md**: Active tasks for GPT-4.1
- **Claude.md files**: Local context in each directory
- **Obsidian Vault**: Permanent documentation
- **Git Commits**: Implementation history

## Session Notes
- Claude 4 upgrade demonstrated significant autonomous capabilities
- Successfully navigated and understood complex codebase
- Created comprehensive implementation plan
- Coordinated multi-AI development effort
- Updated system instructions to match new hybrid documentation approach

## Recent Improvements (May 23, 2025)
- Created `AI_SYSTEM_INSTRUCTIONS.md` with updated workflow
- Emphasized in-codebase documentation as primary source
- Clarified hybrid approach with Obsidian vault as secondary
- Updated root Claude.md with system references

---

*Last Updated: May 23, 2025, 4:15 PM*
