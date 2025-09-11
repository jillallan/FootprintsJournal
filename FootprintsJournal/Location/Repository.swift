//
//  Repository.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 09/09/2025.
//

import Foundation
import SwiftData

@MainActor
final class Repository: Persistable {
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
}
