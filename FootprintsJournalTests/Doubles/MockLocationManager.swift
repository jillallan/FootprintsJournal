//
//  MockLocationManager.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 11/09/2025.
//

import Foundation
import CoreLocation
@testable import FootprintsJournal

class MockLocationManager: LocationProtocol {
    var allowsBackgroundLocationUpdates: Bool
    var authorizationStatus: CLAuthorizationStatus
    
    private let fakeManager = CLLocationManager()
    var delegate: CLLocationManagerDelegate?
    // Track calls if you want
    private(set) var didRequestAlwaysAuth = false
    private(set) var didStartMonitoringVisits = false
    private(set) var didStartUpdatingLocations = false
    private(set) var didStartMonitoringSignificantLocationChanges = false
    var isLocationServicesEnabled: Bool
    static var servicesEnabled: Bool = false
    
    init(
        isLocationServicesEnabled: Bool = true,
        authorizationStatus: CLAuthorizationStatus = .authorizedAlways,
        allowsBackgroundLocationUpdates: Bool = true
    ) {
        self.isLocationServicesEnabled = isLocationServicesEnabled
        self.authorizationStatus = authorizationStatus
        self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
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
    
    func startMonitoringSignificantLocationChanges() {
        didStartMonitoringSignificantLocationChanges = true
    }
    
    func stopMonitoringVisits() {
        didStartMonitoringVisits = false
    }
    
    func stopUpdatingLocation() {
        didStartUpdatingLocations = false
    }
    
    func stopMonitoringSignificantLocationChanges() {
        didStartMonitoringSignificantLocationChanges = true
    }
    // MARK: - Simulation helpers
    
//    func simulateAuthorizationChange() {
//        delegate?.locationManagerDidChangeAuthorization?(fakeManager)
//    }
    
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

