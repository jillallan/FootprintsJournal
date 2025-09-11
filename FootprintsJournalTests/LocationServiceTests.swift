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
    func createRepository() throws -> Persistable {
        let schema = Schema([Location.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try! ModelContainer(
            for: schema,
            configurations: modelConfiguration
        )
        
        let persister = MockRepository(modelContext: modelContainer.mainContext)
        return persister
    }
    
    
    @Test("verifyAuthorizationStatus throws .denied")
    @MainActor
    func deniedAuthorization() async throws {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .denied
        let locationService = LocationService(
            locationManager: mock,
            persister: repository
        )
        mock.authorizationStatus = .denied
        locationService
            .locationManagerDidChangeAuthorization(mock as! CLLocationManager)
        
        #expect(mock.didStartMonitoringVisits == false)
        #expect(mock.didStartMonitoringSignificantLocationChanges == false)
    
    }
    
    @Test("verifyAuthorizationStatus throws .restricted")
    @MainActor
    func restrictedAuthorization() async {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .restricted
        let locationService = LocationService(
            locationManager: mock,
            persister: repository
        )
        mock.authorizationStatus = .restricted
        
        #expect(mock.didStartMonitoringVisits == false)
        #expect(mock.didStartMonitoringSignificantLocationChanges == false)
    }
    
    @Test("verifyAuthorizationStatus throws .upgrade when authorizedWhenInUse")
    @MainActor
    func whenInUseAuthorization() async {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .authorizedWhenInUse
        let locationService = LocationService(
            locationManager: mock,
            persister: repository
        )
        mock.authorizationStatus = .authorizedWhenInUse
        
        #expect(mock.didStartMonitoringVisits == true)
        #expect(mock.didStartMonitoringSignificantLocationChanges == true)
    }

    @Test("verifyAuthorizationStatus returns true when already authorizedAlways")
    @MainActor
    func alreadyAuthorizedAlways() async throws {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .authorizedAlways
        let locationService = LocationService(
            locationManager: mock,
            persister: repository
        )
        mock.authorizationStatus = .authorizedAlways
        
        #expect(mock.didStartMonitoringVisits == true)
        #expect(mock.didStartMonitoringSignificantLocationChanges == true)
    }
    
    @Test
    func visitCallback_createsNewVisitStruct() throws {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .denied
        let service = SpyLocationService(
            locationManager: mock,
            persister: repository
        )
        
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

//        #expect(
//            service.visits.first?.startDate == startDate,
//            "Expected coordinate to be \(startDate), got \(service.visits.first?.startDate)"
//        )

    }
    
    @Test
    func error_isHandled() {
        let mock = MockLocationManager()
        let repository = try! createRepository()
        mock.authorizationStatus = .denied
        let service = SpyLocationService(
            locationManager: mock,
            persister: repository
        )
        
        struct TestError: Error {}
        mock.simulateError(TestError())
        
        #expect(service.receivedErrors.count == 1)
    }
}
