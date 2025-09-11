//
//  LocationController.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 10/09/2025.
//

import CoreLocation
import Foundation

@MainActor
class LocationController: NSObject {
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
    
    func enableLocationFeatures() {
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func disableLocationFeatures() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopMonitoringVisits()
    }
}

extension LocationController: CLLocationManagerDelegate {
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
}
