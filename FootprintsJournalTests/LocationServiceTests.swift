//
//  LocationServiceTests.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 07/09/2025.
//

import CoreLocation
import SwiftData
import Testing
@testable import FootprintsJournal

@MainActor
@Suite
struct LocationServiceDelegateTests {
    var modelContainer: ModelContainer
    var modelContext: ModelContext
    var persistenceController: PersistenceController
    var mock: MockLocationManager
    var service: SpyLocationService
    
    init() {
        let schema = Schema([Location.self, Visit.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(
            for: schema,
            configurations: modelConfiguration
        )
        modelContext = modelContainer.mainContext
        persistenceController = PersistenceController(modelContext: modelContext)
        
        mock = MockLocationManager()
        service = SpyLocationService(
            locationManager: mock,
            persister: persistenceController
        )
    }
    
//    func createRepository() throws -> Persistable {
//        let schema = Schema([Location.self])
//        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
//        let modelContainer = try! ModelContainer(
//            for: schema,
//            configurations: modelConfiguration
//        )
//        
//        let persister = PersistenceController(
//            modelContext: modelContainer.mainContext
//        )
//        return persister
//    }
    
    @Test
    func visitCallback_createsNewVisitStruct() throws {
        let coordinate = CLLocationCoordinate2D(latitude: 50.0, longitude: -1.0)
        let startDate = Date.now
        let endDate = Date.now.addingTimeInterval(600)
        
        // Usage in your test:
        let visit = TestCLVisit(
            coordinate: coordinate,
            horizontalAccuracy: 5,
            arrivalDate: startDate,
            departureDate: endDate
        ) as CLVisit
        mock.simulateVisit(visit)
        
        #expect(service.receivedVisits.count == 1)
    }
    
    @Test("test location call back")
    func locationCallback_createsNewLocationStruct() throws {
        
        // Usage in your test:
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.0),
            altitude: 0.0,
            horizontalAccuracy: 0.0,
            verticalAccuracy: 0.0,
            timestamp: Date.now
        )
       
        mock.simulateLocation([location])
        
        #expect(service.receivedLocations.count == 1)
    }
    
    @Test
    func error_isHandled() {
        let mock = MockLocationManager()
        mock.authorizationStatus = .denied
        let service = SpyLocationService(
            locationManager: mock,
            persister: persistenceController
        )
        
        struct TestError: Error {}
        mock.simulateError(TestError())
        
        #expect(service.receivedErrors.count == 1)
    }
}

