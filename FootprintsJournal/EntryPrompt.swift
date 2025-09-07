//
//  EntryPrompt.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 06/09/2025.
//

import CoreLocation
import Foundation
import FoundationModels

@Generable
struct EntryPrompt {
    @Guide(description: "What happened?")
    var title: String
    @Guide(description: "Describe the experience.")
    var content: String
    @Guide(description: "The latitude of the place")
    let latitude: Double
    @Guide(description: "The longitude of the place")
    let longitude: Double
    @Guide(description: "The date of the visit expressed in seconds since 1970")
    let secondsSince1970: Double
    @Guide(description: "The current temp at the location")
    let temperature: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var date: Date {
        Date(timeIntervalSince1970: secondsSince1970)
    }
    
    static let example = EntryPrompt(
        title: "Visit to the needles",
        content: "I visited the needles yesterday, a lighthouse on the isle of wight",
        latitude: 50.6626,
        longitude: 1.5898,
        secondsSince1970: 1754078807,
        temperature: 10
    )
}

