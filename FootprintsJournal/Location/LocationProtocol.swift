//
//  LocationProtocol.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 08/09/2025.
//

import CoreLocation
import Foundation

protocol LocationProtocol: AnyObject {
    // Mirror CLLocationManager’s delegate
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    var allowsBackgroundLocationUpdates: Bool { get set }
    
    func requestAlwaysAuthorization()
    static func locationServicesEnabled() -> Bool
    func startMonitoringVisits()
    func startUpdatingLocation()
    func startMonitoringSignificantLocationChanges()
    func stopMonitoringVisits()
    func stopUpdatingLocation()
    func stopMonitoringSignificantLocationChanges()
}
