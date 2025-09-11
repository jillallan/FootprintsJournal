//
//  PersistenceTestHelpers.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 11/09/2025.
//

import Foundation
import SwiftData

struct PersistenceTestHelper {
    let schema: Schema
    let config: ModelConfiguration
    let container: ModelContainer
    
    init(
        schema: Schema,
        config: ModelConfiguration,
        container: ModelContainer
    ) async throws {
        self.schema = schema
        self.config = config
        self.container = container
    }
    
    func insetSampleData() {
//        await MainActor.run {
//            Entry.insertSampleData(modelContext: container.mainContext)
//        }
    }
}
