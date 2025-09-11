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
    var startDate: Date
    var endDate: Date
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var debugDescription: String {
        """
        Location:
          startDate: \(startDate)
          arrivalDate: \(endDate)
          latitude: \(latitude)
          longitude: \(longitude)
        """
    }
    
    init(startDate: Date, endDate: Date, latitude: Double, longitude: Double) {
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(clVisit: CLVisit) {
        self.init(
            startDate: clVisit.arrivalDate,
            endDate: clVisit.departureDate,
            latitude: clVisit.coordinate.latitude,
            longitude: clVisit.coordinate.longitude
        )
    }
}
