//
//  LocationService.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 07/09/2025.
//

import CoreLocation
import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
class LocationService: NSObject {
    var locationManager: LocationProtocol
    private let persister: Persistable
//    var visits: [Visit] = []
//    var locations: [Location] = []
    
    init(locationManager: any LocationProtocol = CLLocationManager(),
         persister: Persistable
    ) {
        self.locationManager = locationManager
        self.persister = persister
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
    
    func verifyAuthorizationStatus() throws -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
            case .notDetermined:
                return false
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
    
    func enableLocationFeatures() {
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func disableLocationFeatures() {
        locationManager.stopMonitoringVisits()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func handleNewCLLocation(_ clLocation: CLLocation) {
        let location = Location(clLocation: clLocation)
        do {
            try persister.save(location)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handleNewVisit(_ clVisit: CLVisit) {
        let visit = Visit(clVisit: clVisit)
        persister.save(visit)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Did change authorisation")
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:  // Location services are available.
                print("Authorisation granted")
                enableLocationFeatures()
                break
                
            case .restricted, .denied:  // Location services currently unavailable.
                disableLocationFeatures()
                break
                
            case .notDetermined:        // Authorization not determined yet.
                manager.requestAlwaysAuthorization()
                break
                
            default:
                break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didVisit visit: CLVisit
    ) {
        print(visit.debugDescription)
        handleNewVisit(visit)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        print(locations.first!.debugDescription)
        if let location = locations.first {
            handleNewCLLocation(location)
        }
    }
}

extension CLLocationManager: LocationProtocol { }
