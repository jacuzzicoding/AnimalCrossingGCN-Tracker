AnimalCrossingGCN-Tracker
v0.5.0-alpha (November 23, 2024)
Made by Brock (@jacuzzicoding)
What is this?
A little app I'm making to track museum donations in Animal Crossing GameCube. Built with Swift/SwiftUI because I wanted to learn them better. Works on iPhone, iPad, and Mac (mostly).
v0.5.0-alpha adds some floating category buttons and makes everything look nicer. Built on top of the code cleanup I did in v0.4.3-alpha.
Files
The code is currently in these main files:

ContentView.swift: Main app view - shows lists of fossils, bugs, fish, and art
CollectibleItem.swift: Base stuff that all collectible items share
Fossil.swift: Fossil tracking (25 fossils)
Bug.swift: Bug tracking (40 bugs)
Fish.swift: Fish tracking (40 fish)
Art.swift: Art tracking (13 pieces)

Planning to split this into:

DataManager.swift: For handling data/saving
Models.swift: All the data models
CustomViews.swift: Reusable UI parts
ContentView.swift: Just the main view

What's Working

Museum donation tracking for all items
Search by name
New floating category selector with icons
Better looking item display
Works great on iPhone/iPad
Some Mac support (needs fixes)

v0.5.0-alpha Changes

Added floating category buttons with icons
Made items look better with icons and spacing
Kept SwiftData working the same
iOS version working great
Mac version needs work

Known Issues

Mac breaks when switching categories (#17)
Search only looks in current category
Mac needs more testing
Can't delete items (by design)
Art images not added yet

What's Next
Need to:

Fix Mac category switching
Make search work across all items
Add code file organization:

Split into DataManager/Models/Views
Cleaner separation of code
Easier to add features


Add item stats and graphs
Add sorting and filtering
Add backup/restore
Add other languages
Track donation dates

Platform Support

iPhone/iPad: Working great with new UI
Mac: Basic support but has bugs
Uses SwiftData to save progress
Different layouts for iPhone vs iPad/Mac

Summary
v0.5.0-alpha adds a much better looking UI, especially on iOS. Some Mac bugs to fix to say the least, planning on using an enum to easily seperate the phone & desktop versions. Code cleanup coming next to make future updates easier.
