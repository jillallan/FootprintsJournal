//
//  MockRepository.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 11/09/2025.
//

import Foundation
import SwiftData
@testable import FootprintsJournal

@MainActor
final class MockRepository: Persistable {

    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        modelContext.autosaveEnabled = true
    }
    
    func save(_ location: Location) {
        
    }

    func save(_ visit: Visit) {
        
    }
}
