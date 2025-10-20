//
//  Visit.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 07/09/2025.
//

import CoreLocation
import Foundation
import SwiftData

@Model
class Visit: CustomDebugStringConvertible {
    var arrivalDate: Date
    var departureDate: Date?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: 0.0,
            horizontalAccuracy: 0.0,
            verticalAccuracy: 0.0,
            timestamp: arrivalDate
        )
    }
    
    var debugDescription: String {
        """
        Location:
          arrivalDate: \(arrivalDate)
          departureDate: \(departureDate ?? Date.now)
          latitude: \(latitude)
          longitude: \(longitude)
        """
    }
    
    init(arrivalDate: Date, departureDate: Date, latitude: Double, longitude: Double) {
        self.arrivalDate = arrivalDate
        self.departureDate = departureDate
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(clVisit: CLVisit) {
        self.init(
            arrivalDate: clVisit.arrivalDate,
            departureDate: clVisit.departureDate,
            latitude: clVisit.coordinate.latitude,
            longitude: clVisit.coordinate.longitude
        )
    }
}

