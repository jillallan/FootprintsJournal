//
//  PersistenceController.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 09/09/2025.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController: Persistable {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        modelContext.autosaveEnabled = true
    }
    
    func save(_ location: Location) {
        modelContext.insert(location)
    }
    
    func save(_ visit: Visit) {
        modelContext.insert(visit)
    }
    
    // Generic fetch for any SwiftData model
    func fetch<T: PersistentModel>(
        _ model: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        return try modelContext.fetch(descriptor)
    }
    
    // Convenience fetchers for known models (optional)
    func fetchLocations(
        predicate: Predicate<Location>? = nil,
        sortBy: [SortDescriptor<Location>] = []
    ) throws -> [Location] {
        try fetch(Location.self, predicate: predicate, sortBy: sortBy)
    }
    
    func fetchVisits(
        predicate: Predicate<Visit>? = nil,
        sortBy: [SortDescriptor<Visit>] = []
    ) throws -> [Visit] {
        try fetch(Visit.self, predicate: predicate, sortBy: sortBy)
    }
}
