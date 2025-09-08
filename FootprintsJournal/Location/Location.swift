//
//  Location.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 08/09/2025.
//

import CoreLocation
import Foundation
import SwiftData

@Model
class Location {
    var timestamp: Date
//    var location: CLLocationCoordinate2D
    
    init(timestamp: Date) {
        self.timestamp = timestamp
//        self.location = location
    }
}
