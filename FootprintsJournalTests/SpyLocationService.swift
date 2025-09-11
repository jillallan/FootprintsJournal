//
//  SpyLocationService.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 11/09/2025.
//

import Foundation
import CoreLocation
@testable import FootprintsJournal

@MainActor
final class SpyLocationService: LocationService {
    private(set) var didReceiveAuthorizationChange = false
    private(
        set
    ) var authorizationStatus: CLAuthorizationStatus? = .notDetermined
    private(set) var receivedVisits: [CLVisit] = []
    private(set) var receivedLocations: [CLLocation] = []
    private(set) var receivedErrors: [Error] = []
    
    override func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didReceiveAuthorizationChange = true
        authorizationStatus = manager.authorizationStatus
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
