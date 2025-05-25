//
//  DependencyContainer.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/22/25.
//

import Foundation
import SwiftUI
import Combine

/// A simple dependency injection container for managing service instances
class DependencyContainer: ObservableObject {
    // MARK: - Properties
    
    /// Dictionary to store singleton instances
    private var singletons: [String: Any] = [:]
    
    /// Dictionary to store factory closures
    private var factories: [String: () -> Any] = [:]
    
    /// Thread safety queue
    private let queue = DispatchQueue(label: "com.animalcrossinggcn.dependencycontainer", attributes: .concurrent)
    
    // MARK: - Singleton Registration
    
    /// Registers a singleton instance for a given protocol type
    /// - Parameters:
    ///   - type: The protocol type to register
    ///   - instance: The instance conforming to the protocol
    func register<T>(type: T.Type, instance: T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.singletons[key] = instance
        }
    }
    
    // MARK: - Factory Registration
    
    /// Registers a factory closure for creating instances
    /// - Parameters:
    ///   - type: The protocol type to register
    ///   - factory: A closure that creates instances conforming to the protocol
    func register<T>(type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
        }
    }
    
    // MARK: - Dependency Resolution
    
    /// Resolves and returns an instance for the given protocol type
    /// - Parameter type: The protocol type to resolve
    /// - Returns: An instance conforming to the protocol
    /// - Throws: DependencyContainerError if the dependency cannot be resolved
    func resolve<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)
        
        return try queue.sync {
            // Check singletons first
            if let instance = singletons[key] as? T {
                return instance
            }
            
            // Check factories next
            if let factory = factories[key], let instance = factory() as? T {
                return instance
            }
            
            throw DependencyContainerError.dependencyNotFound(key)
        }
    }
    
    // MARK: - Container Management
    
    /// Clears all registered singletons and factories
    /// Useful for testing or resetting the container
    func reset() {
        queue.async(flags: .barrier) {
            self.singletons.removeAll()
            self.factories.removeAll()
        }
    }
    
    /// Checks if a dependency is registered
    /// - Parameter type: The protocol type to check
    /// - Returns: True if the dependency is registered, false otherwise
    func isRegistered<T>(_ type: T.Type) -> Bool {
        let key = String(describing: type)
        return queue.sync {
            singletons[key] != nil || factories[key] != nil
        }
    }
}

// MARK: - Error Types

/// Errors that can occur during dependency resolution
enum DependencyContainerError: Error, LocalizedError {
    case alreadyRegistered(String)
    case dependencyNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .alreadyRegistered(let key):
            return "Dependency '\(key)' is already registered."
        case .dependencyNotFound(let key):
            return "Dependency '\(key)' could not be resolved. Ensure it's registered before use."
        }
    }
}

// MARK: - SwiftUI Environment Integration

/// Environment key for the dependency container
struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer()
}

/// Extension to add dependency container to SwiftUI environment
extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

// MARK: - View Extension for Easy Access

extension View {
    /// Injects the dependency container into the SwiftUI environment
    /// - Parameter container: The dependency container to inject
    /// - Returns: A view with the container in its environment
    func withDependencies(_ container: DependencyContainer) -> some View {
        environment(\.dependencyContainer, container)
    }
}
