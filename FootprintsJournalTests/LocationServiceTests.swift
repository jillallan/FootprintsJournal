//
//  LocationServiceTests.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 07/09/2025.
//

import CoreLocation
import Testing
@testable import FootprintsJournal

class MockLocationManager: LocationProtocol {
    var authorizationStatus: CLAuthorizationStatus

    private let fakeManager = CLLocationManager()
    var delegate: CLLocationManagerDelegate?
    // Track calls if you want
    private(set) var didRequestAlwaysAuth = false
    private(set) var didStartMonitoringVisits = false
    private(set) var didStartUpdatingLocations = false
    var isLocationServicesEnabled: Bool
    static var servicesEnabled: Bool = false
    
    init(
        isLocationServicesEnabled: Bool = true,
        authorizationStatus: CLAuthorizationStatus = .authorizedAlways
    ) {
        self.isLocationServicesEnabled = isLocationServicesEnabled
        self.authorizationStatus = authorizationStatus
        MockLocationManager.servicesEnabled = isLocationServicesEnabled
    }

    func requestAlwaysAuthorization() {
        didRequestAlwaysAuth = true
    }

    static func locationServicesEnabled() -> Bool {
        true
    }

    func startMonitoringVisits() {
        didStartMonitoringVisits = true
    }
    
    func startUpdatingLocation() {
        didStartUpdatingLocations = true
    }
    
    // MARK: - Simulation helpers
    
    func simulateAuthorizationChange() {
        delegate?.locationManagerDidChangeAuthorization?(fakeManager)
    }
    
    func simulateVisit(_ visit: CLVisit) {
        delegate?.locationManager?(fakeManager, didVisit: visit)
    }
    
    func simulateLocation(_ locations: [CLLocation]) {
        delegate?.locationManager?(fakeManager, didUpdateLocations: locations)
    }
    
    func simulateError(_ error: Error) {
        delegate?.locationManager?(fakeManager, didFailWithError: error)
    }

}

import CoreLocation
@testable import FootprintsJournal

@MainActor
final class SpyLocationService: LocationService {
    private(set) var didReceiveAuthorizationChange = false
    private(set) var receivedVisits: [CLVisit] = []
    private(set) var receivedLocations: [CLLocation] = []
    private(set) var receivedErrors: [Error] = []
    
    override func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didReceiveAuthorizationChange = true
        super.locationManagerDidChangeAuthorization(manager)
    }
    
    override func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        receivedVisits.append(visit)
        super.locationManager(manager, didVisit: visit)
    }
    
    override func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        receivedLocations.append(contentsOf: locations)
        super.locationManager(manager, didUpdateLocations: locations)
    }
    
    override func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        receivedErrors.append(error)
        super.locationManager(manager, didFailWithError: error)
    }
}

import CoreLocation

final class TestCLVisit: CLVisit {
    private let _coordinate: CLLocationCoordinate2D
    private let _horizontalAccuracy: CLLocationAccuracy
    private let _arrivalDate: Date
    private let _departureDate: Date
    
    init(
        coordinate: CLLocationCoordinate2D,
        horizontalAccuracy: CLLocationAccuracy,
        arrivalDate: Date,
        departureDate: Date
    ) {
        self._coordinate = coordinate
        self._horizontalAccuracy = horizontalAccuracy
        self._arrivalDate = arrivalDate
        self._departureDate = departureDate
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var coordinate: CLLocationCoordinate2D { _coordinate }
    override var horizontalAccuracy: CLLocationAccuracy { _horizontalAccuracy }
    override var arrivalDate: Date { _arrivalDate }
    override var departureDate: Date { _departureDate }
}


// MARK: - Tests

@MainActor
@Suite
struct LocationServiceDelegateTests {
    @Test("verifyAuthorizationStatus throws .denied")
    @MainActor
    func deniedAuthorization() async {
        let mock = MockLocationManager()
        mock.authorizationStatus = .denied
        let locationService = LocationService(locationManager: mock)
        
        await #expect(throws: LocationError.denied) {
            _ = try await locationService.verifyAuthorizationStatus()
        }
    }
    
    @Test("verifyAuthorizationStatus throws .restricted")
    @MainActor
    func restrictedAuthorization() async {
        let mock = MockLocationManager()
        mock.authorizationStatus = .restricted
        let service = LocationService(locationManager: mock)
        
        await #expect(throws: LocationError.restricted) {
            _ = try await service.verifyAuthorizationStatus()
        }
    }
    
    @Test("verifyAuthorizationStatus throws .upgrade when authorizedWhenInUse")
    @MainActor
    func whenInUseAuthorization() async {
        let mock = MockLocationManager()
        mock.authorizationStatus = .authorizedWhenInUse
        let service = LocationService(locationManager: mock)
        
        await #expect(throws: LocationError.upgrade) {
            _ = try await service.verifyAuthorizationStatus()
        }
    }

    @Test("verifyAuthorizationStatus returns true when already authorizedAlways")
    @MainActor
    func alreadyAuthorizedAlways() async throws {
        let mock = MockLocationManager()
        mock.authorizationStatus = .authorizedAlways
        let service = LocationService(locationManager: mock)
        
        let result = try await service.verifyAuthorizationStatus()
        #expect(result == true)
    }
    
    @Test
    func visitCallback_createsNewVisitStruct() throws {
        let mockManager = MockLocationManager()
        let service = SpyLocationService(locationManager: mockManager)
        
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
        mockManager.simulateVisit(visit)
        
        #expect(service.receivedVisits.count == 1)
        #expect(service.visits.count == 1)
//        #expect(
//            service.visits.first?.location == coordinate,
//            "Expected coordinate to be \(coordinate), got \(service.visits.first?.location)"
//        )
        #expect(
            service.visits.first?.startDate == startDate,
            "Expected coordinate to be \(startDate), got \(service.visits.first?.startDate)"
        )
        #expect(
            service.visits.first?.endDate == endDate,
            "Expected coordinate to be \(endDate), got \(service.visits.first?.endDate)"
        )
    }
    
    @Test
    func authChange_isHandled() {
        let mockManager = MockLocationManager()
        let service = SpyLocationService(locationManager: mockManager)
        
        mockManager.simulateAuthorizationChange()
        
        #expect(service.didReceiveAuthorizationChange)
    }
    
    @Test
    func error_isHandled() {
        let mockManager = MockLocationManager()
        let service = SpyLocationService(locationManager: mockManager)
        
        struct TestError: Error {}
        mockManager.simulateError(TestError())
        
        #expect(service.receivedErrors.count == 1)
    }
}
