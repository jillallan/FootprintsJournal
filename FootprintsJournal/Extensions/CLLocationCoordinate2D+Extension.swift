//
//  CLLocationCoordinate2D+Extension.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 08/09/2025.
//


import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    
//    var description: String {
//        "(\(latitude), \(longitude))"
//    }
}
