# v0.7.0-alpha-preview-6 Planning

## Branch Information
- **Development Branch:** `claude/incomplete-description-011CV16vZXL71xQwkgsZKCyv`
- **Target Version:** v0.7.0-alpha-preview-6
- **Status:** In Development
- **Created:** November 11, 2025

## Planned Features for Preview-6

### ✅ Completed
- **HomeView Modularization** (November 11, 2025)
  - Extracted 6 component files from 779-line HomeView.swift
  - New components: HomeHeaderView, CollectionStatusCard, CategoryGridView, SeasonalHighlightsCard, RecentDonationsCard, ColorExtensions
  - Reduced HomeView.swift from 779 lines → 79 lines (90% reduction)
  - Commit: `36ac9c3` - refactor: modularize HomeView into separate component files

### 🚧 In Progress
- None currently

### 📋 Planned
- Implement Donate Tab (from preview-5 checklist)
- Additional large file refactoring:
  - AnalyticsDashboardView.swift (948 lines)
  - DataManager.swift (923 lines)
  - ContentView.swift (645 lines)

## Pull Request Checklist

When ready to merge to main:
- [ ] All planned features completed
- [ ] Code builds without errors
- [ ] Update README.md with v0.7.0-alpha-preview-6 section
- [ ] Mark "Complete HomeView modularization" as ✅ in README
- [ ] Test on iOS and macOS
- [ ] Create PR from `claude/incomplete-description-011CV16vZXL71xQwkgsZKCyv` to `main`
- [ ] Update version number in project

## Notes
- This branch continues the modularization work started in preview-5
- Focus on breaking up large files (>500 lines) into maintainable components
- Following established patterns from existing component architecture

## Related Documentation
- README.md - Main project documentation
- AnimalCrossingGCN-Tracker/Documentation/GlobalSearch.md
- AnimalCrossingGCN-Tracker/Documentation/MacOS_Category_Switching_Fix.md
