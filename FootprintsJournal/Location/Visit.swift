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
class Visit {
    var startDate: Date
    var endDate: Date
//    var location: CLLocationCoordinate2D
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
//        self.location = location
    }
    
    convenience init(clVisit: CLVisit) {
        self.init(startDate: clVisit.arrivalDate, endDate: clVisit.departureDate)
//        self.location = clVisit.coordinate
    }
}
