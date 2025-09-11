//
//  DataController.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 08/09/2025.
//

import CoreLocation
import Foundation
import SwiftData

class DataController {
    var container: ModelContainer
    var config: ModelConfiguration
    var schema: Schema
    var modelContext: ModelContext
    
    @MainActor
    init(
        config: ModelConfiguration = ModelConfiguration(
            isStoredInMemoryOnly: false
        ),
        schema: Schema = Schema(Location.self)
    ) {
        self.config = config
        self.schema = schema
        do {
            container = try ModelContainer(for: schema, configurations: [config])
            modelContext = container.mainContext
        } catch {
            fatalError("Fatal error loading ModelContainer")
        }
    }
    
    static func addVisit(
        modelContext: ModelContext,
        clVisit: CLVisit
    ) {
        let newVisit = Visit(clVisit: clVisit)
        modelContext.insert(newVisit)
    }
}

