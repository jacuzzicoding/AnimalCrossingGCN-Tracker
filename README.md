**AnimalCrossingGCN-Tracker - Project Document

-Version: v1.10.14.24.a

-Pre-Release Date: October 14, 2024

-Author: Brock Jenkinson**

**Project Overview**
The AnimalCrossingGCN-Tracker is a companion app designed for players of the original Animal Crossing on the GameCube. The app helps users track museum collectibles, including fossils, bugs, fish, and art. It is built using Swift and SwiftUI, with SwiftData ensuring data persistence across iPhone, iPad, and macOS devices.

Version v1.10.11.24 introduced a major update with the addition of art tracking, completing the four main museum sections (fossils, bugs, fish, and art). The app now provides comprehensive tracking for all these categories. Upcoming updates will focus on polishing the user experience by adding sound effects, haptics, and a more visually appealing interface.

The latest update, v1.10.14.24.a, is a beta release that primarily addresses bug fixes and optimizations based on feedback from version v1.10.11.24.

**File Structure**
ContentView.swift: Manages the main view, displaying fossils, bugs, fish, and art. It adapts layouts for different devices using NavigationStack (for iPhones) and NavigationSplitView (for iPads and macOS). A search bar allows users to easily find specific collectibles by name, and the section selector provides quick navigation between the different collectible types.

Fossil.swift: Defines the Fossil data model, including the fossil’s name, optional part information, and donation status. Pre-populated with all 25 fossils from Animal Crossing for GameCube.

Bug.swift: Defines the Bug data model, with fields for bug name, season availability, and donation status. The app includes 40 bugs from the game.

Fish.swift: Defines the Fish data model, covering name, season availability, location (river, sea, or pond), and donation status. Includes all 40 fish from the game.

Art.swift: Defines the Art data model, including the in-game name, real-world artwork name, and donation status. Pre-populated with all 13 paintings from the game.

AnimalCrossingGCN_TrackerApp.swift: Entry point of the app, responsible for managing the app’s lifecycle and initializing the SwiftData model container.

AnimalCrossingGCN_TrackerTests.swift and AnimalCrossingGCN_TrackerUITests.swift: Handle unit and UI tests to ensure app functionality and responsiveness. These tests are still in development.

Current Features
Tracking for fossils, bugs, fish, and art: Each category comes pre-populated with respective items from Animal Crossing on the GameCube. Users can toggle donation statuses and view detailed information for each collectible. SwiftData ensures data persistence across sessions.

Search Functionality: A search bar enables users to quickly find items by name, streamlining navigation through large collections.

Device-Adaptive UI: Uses NavigationStack for iPhones and NavigationSplitView for iPads and macOS, adapting seamlessly across platforms.

Art Tracking: The latest major update (v1.10.11.24) added tracking for the 13 art pieces featured in the North American version of Animal Crossing. Users can view information about the in-game name and real-world artwork.

Issues & Limitations
Deletion of Items: The app does not currently support the deletion of items from the collection. A future update will either introduce this feature or remove the delete option altogether.

DetailView: The DetailView for each section is still under development and only fully functional on macOS. Further updates are planned to ensure consistent behavior across all platforms.

Future Steps
Data Visualization: Future updates will introduce features like progress graphs to track donation status over time. Users will be able to toggle between fossils, bugs, fish, and art on the graphs.

Filtering Options: Planned updates will allow users to filter items by donation status, season availability, and collectible type.

Data Import/Export: A future feature will allow users to back up their collection data and transfer it across devices.

Localization: The app will eventually support multiple languages to make it more accessible to non-English-speaking players.

Polish and Performance: Sound effects, haptics, and visual refinements will be introduced to enhance the user experience, especially on mobile devices.

TLDR;
Version v1.10.11.24 was a significant milestone, introducing full art tracking and completing the app’s primary functionality. The current beta release, v1.10.14.24.a, focuses on bug fixes and optimizations in preparation for a more polished and feature-rich version. With upcoming updates, the app will continue to evolve with new features like data visualization, filtering, and improved UI/UX.
