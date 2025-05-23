# Development Decisions Log

## Purpose
Quick record of implementation decisions made during development. For architectural decisions, see ADRs in Obsidian vault.

## May 22, 2025

### Dependency Injection Implementation
- **Decision**: Use simple protocol-based DI with manual container
- **Rationale**: 
  - Avoids heavy third-party dependencies
  - Easy to understand and debug
  - Sufficient for current app complexity
- **Alternative Considered**: Swinject, Resolver
- **Made By**: Claude 4

### Claude.md Documentation Pattern
- **Decision**: Add Claude.md files throughout codebase
- **Rationale**:
  - Immediate context when browsing code
  - Reduces context switching
  - AI assistants can understand modules quickly
- **Alternative Considered**: Keep all docs in Obsidian only
- **Made By**: Claude 4 (with Brock's approval)

### Service Naming Convention
- **Decision**: Rename services to *Impl pattern
- **Rationale**:
  - Clear distinction between protocol and implementation
  - Standard Swift pattern
  - Makes DI intentions obvious
- **Alternative Considered**: Keep original names, use modules
- **Made By**: Claude 4

## May 21, 2025

### Error Handling Strategy
- **Decision**: Comprehensive error types with context
- **Rationale**:
  - Better debugging information
  - User-friendly error messages
  - Consistent error handling
- **Alternative Considered**: Simple error strings
- **Made By**: Team consensus

## May 19, 2025

### Repository Pattern Implementation
- **Decision**: Use generic BaseRepository with extensions
- **Rationale**:
  - Reduces code duplication
  - Consistent interface
  - Easy to extend
- **Alternative Considered**: Individual repositories without base
- **Made By**: Development team

## Guidelines for Decisions

### What Goes Here
- Implementation choices
- Technical decisions
- Tool selections
- Pattern applications

### What Needs an ADR
- Architectural changes
- Major pattern shifts
- Technology stack changes
- Breaking changes

### Decision Template
```markdown
### [Decision Title]
- **Decision**: What was decided
- **Rationale**: Why this choice
- **Alternative Considered**: Other options
- **Made By**: Who made the decision
- **Date**: When it was made
```

---

*Decision Log - Maintained by AI Assistants*
