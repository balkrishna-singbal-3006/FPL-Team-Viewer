FPL Team Viewer App
- 


A highly performant iOS application built to browse football teams and explore comprehensive player squad details.


**🌟 Key Features**
* Team List: Browse a list of available football teams.
* Squad Detail Explorer: View individual squad rosters grouped categorically by player positions.
* Real-Time Search: Instantly filter squad members dynamically by name.
* Smart Sorting Toggle: Order player lists fluidly by FPL Points or Price with explicit fallback tie-breakers.
* Offline Fallback Caching: Graceful network-loss resilience that keeps old records readable across separate launches.
* Integrated Pull-to-Refresh & Recovery: Pull down to update raw endpoints smoothly, backed by a dedicated error recovery layout with dedicated retry mechanisms.


**🏗️ Architecture & Design Patterns**

The codebase strictly adheres to Clean Architecture and SOLID design principles, prioritizing testability, clear boundary separations, and horizontal maintainability.

**Module Topology**

The application leverages a Multi-Module Platform Architecture. By splitting business responsibilities into isolated, independent framework layers, compilation speeds are optimized, and feature boundaries remain completely decoupled. I have used Swift Package Manager (SPM) for creating local package (modules) and for their integration.

**Presentation Layer (MVVM-C)**

* Model-View-ViewModel (MVVM): Offloads complex data transformations, state manipulation, and list sorting logic directly out of view components.
* Coordinator Pattern: Completely decouples application routing and screen presentation rules from the UIKit lifecycle.
* Protocol-Oriented Programming (POP): All core dependencies are defined via structural protocols to ensure seamless mock generation during testing cycles.
* Dependency Injection (DI): Explicit initializers are used to inject dependencies.

**Modern Concurrency**

The application fully adopts Swift Structured Concurrency (async/await). It leverages modern Swift thread isolation protocols (such as actors and @MainActor alignments) to safeguard code blocks against potential data race anomalies.

**💾 Storage & Data Management**

**Persistent Offline Caching**

To maintain high offline availability, a dedicated, asynchronous TeamsCacheService entity manages local data persistence:
* Utilizes FileManager atomic disk updates inside the device Caches directory to prevent data corruption.
* Extends default Error handling to intercept selective connectivity failures (e.g., lost internet connection or timeouts).

**UI State Automation**

The layout architecture drives cell updates using UITableViewDiffableDataSource:
* Eliminates error-prone manual reloadData() indexing.
* Automatically handles dynamic transitions and animations when list elements shift order or update content states.


**Improvements:**
1. Have a Swinject like container for Dependency Injection(DI) of plugins.
2. Create a separate Networking Library.
3. Add support for localization & accessibility.
4. Write more unit test cases.
