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
class Location: CustomDebugStringConvertible {
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var horizontalAccuracy: Double
    var verticalAccuracy: Double
    var altitude: Double
    var course: Double
    var speed: Double


    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            course: course,
            speed: speed,
            timestamp: timestamp
        )
    }

    init(
        timestamp: Date,
        latitude: Double,
        longitude: Double,
        horizontalAccuracy: Double,
        verticalAccuracy: Double,
        altitude: Double,
        course: Double,
        speed: Double
    ) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.altitude = altitude
        self.course = course
        self.speed = speed
    }
    
    var debugDescription: String {
        """
        Location:
          timestamp: \(timestamp)
          latitude: \(latitude)
          longitude: \(longitude)
          altitude: \(altitude) m
          horizontalAccuracy: \(horizontalAccuracy) m
          verticalAccuracy: \(verticalAccuracy) m
          course: \(course)°
          speed: \(speed) m/s
        """
    }
    
    convenience init(clLocation: CLLocation) {
        self.init(
            timestamp: clLocation.timestamp,
            latitude: clLocation.coordinate.latitude,
            longitude: clLocation.coordinate.longitude,
            horizontalAccuracy: clLocation.horizontalAccuracy,
            verticalAccuracy: clLocation.verticalAccuracy,
            altitude: clLocation.altitude,
            course: clLocation.course,
            speed: clLocation.speed
        )
    }
}

extension Location {
    static var preview: Location {
        Location(
            timestamp: Date.now,
            latitude: 51.5,
            longitude: 0.0,
            horizontalAccuracy: 0.0,
            verticalAccuracy: 0.0,
            altitude: 0.0,
            course: 0.0,
            speed: 0.0
        )
    }
}
