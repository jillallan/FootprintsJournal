//
//  RepositoryTests.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 12/09/2025.
//

import Foundation
import SwiftData
import Testing
@testable import FootprintsJournal

@MainActor
struct PersistenceControllerTests {
    var modelContainer: ModelContainer
    var modelContext: ModelContext
    var persistenceController: PersistenceController
    
    init() {
        let schema = Schema([Location.self, Visit.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(
            for: schema,
            configurations: modelConfiguration
        )
        modelContext = modelContainer.mainContext
        persistenceController = PersistenceController(modelContext: modelContext)
    }
    
    @Test func savingLocations_IncrementsLocationsByOne() async throws {
 
        let location = Location(
            timestamp: Date.now,
            latitude: 51.5,
            longitude: 0.0,
            horizontalAccuracy: 0.0,
            verticalAccuracy: 0.0,
            altitude: 0.0,
            course: 0.0,
            speed: 0.0
        )
        persistenceController.save(location)
        
        let locations = try persistenceController.fetchLocations()
        
        #expect(
            locations.count == 1,
            "locations count should be 1, but is \(locations.count)"
        )
        #expect(locations.first?.latitude == 51.5)
    }
    
    @Test func savingLVisits_IncrementsVisitsByOne() async throws {

        let visit = Visit(
                        arrivalDate: Date.now,
                        departureDate: Date.now.addingTimeInterval(600),
            latitude: 10.0,
            longitude: 10.0
        )
        persistenceController.save(visit)
        
        let visits = try persistenceController.fetchVisits()
        
        #expect(
            visits.count == 1,
            "visits count should be 1, but is \(visits.count)"
        )
        #expect(visits.first?.latitude == 10.0)
    }
    
    @Test func newModelContextHasNoModels() async throws {

        let visitCount = try persistenceController.fetchVisits().count
        
        #expect(
            visitCount == 0,
            "visits count should be 0, but is \(visitCount)"
        )
    }
    
    @Test("Fetching with Predicate returns filtered results")
    func testFetchWithPredicate() async throws {
        let loc1 = Location(
            timestamp: .now,
            latitude: 5.0,
            longitude: 5.0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            altitude: 0,
            course: 0,
            speed: 0
        )
        let loc2 = Location(
            timestamp: .now,
            latitude: 10.0,
            longitude: 10.0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            altitude: 0,
            course: 0,
            speed: 0
        )
        persistenceController.save(loc1)
        persistenceController.save(loc2)
        let predicate = #Predicate<Location> { $0.latitude > 7.0 }
        let filtered = try persistenceController.fetchLocations(predicate: predicate)
        #expect(filtered.count == 1)
        #expect(filtered.first?.latitude == 10.0)
    }
    
    @Test("Fetch returns sorted results")
    func testFetchSorted() async throws {
        let loc1 = Location(
            timestamp: .now,
            latitude: 1.0,
            longitude: 1.0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            altitude: 0,
            course: 0,
            speed: 0
        )
        let loc2 = Location(
            timestamp: .now,
            latitude: 9.0,
            longitude: 9.0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            altitude: 0,
            course: 0,
            speed: 0
        )
        persistenceController.save(loc1)
        persistenceController.save(loc2)
        let sorted = try persistenceController.fetchLocations(sortBy: [SortDescriptor(\.latitude, order: .reverse)])
        #expect(sorted.first?.latitude == 9.0)
    }
}
