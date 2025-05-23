# Animal Crossing GCN Tracker - AI Development Guide

## Project Overview
A SwiftUI application for tracking museum donations in Animal Crossing GameCube. This codebase uses modern Swift patterns and is optimized for AI-assisted development.

## Quick Start for AI Assistants
1. **Check Status**: Read `.claude/WORKING_MEMORY.md` for current state
2. **Find Tasks**: See `.claude/TASK_BOARD.md` for work items
3. **Understand Module**: Read `Claude.md` in the relevant directory
4. **Follow Patterns**: Check architectural decisions in `/Documentation/ADRs/`

## Project Structure
```
/AnimalCrossingGCN-Tracker/
├── /App/              # App initialization and configuration
├── /Models/           # SwiftData models and protocols
├── /Views/            # SwiftUI views and ViewModels
├── /Services/         # Business logic and data services
├── /Repositories/     # Data access layer
├── /Protocols/        # Protocol definitions for DI
├── /Utilities/        # Helper classes and extensions
└── /.claude/          # AI working memory and tasks
```

## Current Architecture

### Key Patterns
- **Repository Pattern**: Data access abstraction
- **Service Layer**: Business logic separation
- **MVVM**: View-ViewModel separation
- **Dependency Injection**: Protocol-based DI with container
- **Error Handling**: Comprehensive error types and propagation

### Technology Stack
- **SwiftUI**: Modern declarative UI
- **SwiftData**: Apple's new persistence framework
- **Combine**: Reactive programming for data flow
- **Swift 5.9+**: Latest language features

## AI Collaboration Guidelines

### Task Distribution
- **Claude 4**: Architecture, planning, complex problem-solving
- **Gemini 2.5 Pro**: Large refactoring, codebase analysis
- **GPT-4.1**: Implementation, documentation, testing
- **GPT-o3-mini**: Quick fixes, simple tasks

### Working With This Codebase
1. **Always check** `.claude/WORKING_MEMORY.md` first
2. **Update Claude.md** files when making significant changes
3. **Follow existing patterns** - consistency is key
4. **Test your changes** - the app should always compile
5. **Document decisions** in `.claude/DECISIONS.md`

## Current Focus Areas
- ✅ Repository Pattern Implementation
- ✅ Service Layer Architecture
- ✅ Error Handling System
- 🔄 Dependency Injection Implementation
- 🔄 UI Component Modularization
- ⏳ Donate Tab Implementation
- ⏳ Unit Testing

## Key Files to Understand
- `/App/AnimalCrossingGCN_TrackerApp.swift` - App entry point
- `/Services/DataManager.swift` - Central data coordination
- `/Models/Protocols/CollectibleItem.swift` - Core protocol
- `/.claude/TASK_BOARD.md` - Current work items
- `/Protocols/` - Service protocols for DI

## Development Workflow
1. **Start Session**: Read `.claude/WORKING_MEMORY.md`
2. **Pick Task**: Choose from `.claude/TASK_BOARD.md`
3. **Understand Context**: Read relevant `Claude.md` files
4. **Implement**: Follow patterns and guidelines
5. **Update Docs**: Update Claude.md and working memory
6. **Communicate**: Use `Copilot.md` for cross-AI communication

## Recent Achievements (May 22, 2025)
- Implemented service protocols for dependency injection
- Created DependencyContainer with SwiftUI integration
- Set up foundation for DI migration
- Improved development system with Claude.md files

## Next Major Milestones
1. Complete dependency injection implementation
2. Implement Donate Tab feature
3. Add comprehensive unit testing
4. Performance optimization pass
5. Prepare for v1.0.0 release

## Need Help?
- **System Instructions**: See `AI_SYSTEM_INSTRUCTIONS.md` for complete AI guidance
- **Architecture Questions**: Check ADRs in Obsidian vault
- **Current State**: Read `.claude/WORKING_MEMORY.md`
- **Module Help**: Read Claude.md in that directory
- **Task Clarity**: Check `.claude/TASK_BOARD.md`

## Documentation System
This project uses a **hybrid documentation approach**:
- **In-Codebase** (`.claude/` + `Claude.md` files): Active development, immediate context
- **Obsidian Vault**: Permanent documentation, ADRs, long-term planning

Start with in-codebase documentation, consult Obsidian for deeper architectural context.

---

*Last Updated: May 23, 2025 by Claude 4*
