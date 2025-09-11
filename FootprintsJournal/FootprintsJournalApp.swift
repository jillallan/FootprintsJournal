//
//  FootprintsJournalApp.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import SwiftUI
import SwiftData

@main
struct FootprintsJournalApp: App {
    let sharedModelContainer: ModelContainer
    let repository: Repository
    @State private var locationService: LocationService
    
    init() {
        let schema = Schema([
            Entry.self,
            Location.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.sharedModelContainer = container
            
            // Now you can use sharedModelContainer!
            self.repository = Repository(modelContext: container.mainContext)
            _locationService = State(wrappedValue: LocationService(persister: self.repository))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Entry.self,
//            Location.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
//    let repository = Repository(modelContext: sharedModelContainer.mainContext)
//    @State private var locationService = LocationService(persister: repository)

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environment(locationService)
    }
}
