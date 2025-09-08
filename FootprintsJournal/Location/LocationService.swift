//
//  LocationService.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 07/09/2025.
//

import CoreLocation
import Foundation
import SwiftData

@MainActor
class LocationService: NSObject {
    var locationManager: LocationProtocol
    var visits: [Visit] = []
    var locations: [Visit] = []
    private var authorizationContinuation: CheckedContinuation<Bool, Never>?
    
    
    init(
        locationManager: any LocationProtocol = CLLocationManager()
    ) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
    
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
            case .notDetermined:
                return await requestAlwaysAuthorization()
            case .restricted:
                throw LocationError.restricted
            case .denied:
                throw LocationError.denied
            case .authorizedAlways:
                return true
            case .authorizedWhenInUse:
                throw LocationError.upgrade
            @unknown default:
                throw LocationError.unknown
        }
    }

    func requestAlwaysAuthorization() async -> Bool {
        // If location services are disabled at the system level, nothing to request.
        guard type(of: locationManager).locationServicesEnabled() else {
            return false
        }
        
        // If already determined, return immediately.
        switch locationManager.authorizationStatus {
            case .authorizedAlways:
                return true
            case .denied, .restricted:
                return false
            case .authorizedWhenInUse, .notDetermined:
                break
            @unknown default:
                return false
        }
        
        // Suspend and wait for delegate callback.
        return await withCheckedContinuation { continuation in
            self.authorizationContinuation = continuation
            // Qualify with the instance to fix “Cannot find 'requestAlwaysAuthorization' in scope”
            self.locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    func startMonitoringVisits() {
        locationManager.startMonitoringVisits()
    }
    
    func startLocationServices() {
        locationManager.startUpdatingLocation()
    }

    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let continuation = authorizationContinuation else { return }
        switch manager.authorizationStatus {
            case .authorizedAlways:
                continuation.resume(returning: true)
            case .authorizedWhenInUse, .denied, .restricted:
                continuation.resume(returning: false)
            case .notDetermined:
                return // still waiting
            @unknown default:
                continuation.resume(returning: false)
        }
        authorizationContinuation = nil
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didVisit visit: CLVisit
    ) {
        print(visit.debugDescription)
        let newVisit = Visit(
            startDate: visit.arrivalDate,
            endDate: visit.departureDate,
//            location: visit.coordinate
        )
        visits.append(newVisit)
//        dataManager.modelContext.insert(newVisit)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        print(locations.first!.debugDescription)
    }
}



extension CLLocationManager: LocationProtocol { }
