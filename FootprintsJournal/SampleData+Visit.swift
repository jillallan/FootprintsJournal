//
//  SampleData-Visit.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 24/09/2025.
//

import Foundation
import SwiftData

extension Visit {
    // Helper to build fixed dates in UTC for reproducible sample data
    private static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var comps = DateComponents()
        comps.calendar = Calendar(identifier: .gregorian)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        comps.year = year
        comps.month = month
        comps.day = day
        comps.hour = hour
        comps.minute = minute
        return comps.date ?? Date()
    }

    // Single sample visit
    static let sample1 = Visit(
        arrivalDate: date(2025, 9, 20, 9, 0),
        departureDate: date(2025, 9, 20, 10, 0),
        latitude: 51.5194,
        longitude: -0.1270
    )

    // Day 1: 4 visits
    static let day1: [Visit] = [
        Visit(arrivalDate: date(2025, 9, 20, 9, 0),  departureDate: date(2025, 9, 20, 10, 0), latitude: 51.5194, longitude: -0.1270), // British Museum
        Visit(arrivalDate: date(2025, 9, 20, 11, 30), departureDate: date(2025, 9, 20, 12, 30), latitude: 51.5116, longitude: -0.1233), // Covent Garden
        Visit(arrivalDate: date(2025, 9, 20, 14, 0),  departureDate: date(2025, 9, 20, 15, 0), latitude: 51.5138, longitude: -0.0984), // St Paul's
        Visit(arrivalDate: date(2025, 9, 20, 16, 30), departureDate: date(2025, 9, 20, 17, 30), latitude: 51.5055, longitude: -0.0900)  // Borough Market
    ]

    // Day 2: 5 visits
    static let day2: [Visit] = [
        Visit(arrivalDate: date(2025, 9, 21, 9, 30),  departureDate: date(2025, 9, 21, 10, 30), latitude: 51.5081, longitude: -0.0759), // Tower of London
        Visit(arrivalDate: date(2025, 9, 21, 12, 0),  departureDate: date(2025, 9, 21, 13, 0), latitude: 51.5107, longitude: -0.0837), // Sky Garden
        Visit(arrivalDate: date(2025, 9, 21, 14, 30), departureDate: date(2025, 9, 21, 15, 30), latitude: 51.5076, longitude: -0.0994), // Tate Modern
        Visit(arrivalDate: date(2025, 9, 21, 17, 0),  departureDate: date(2025, 9, 21, 18, 0), latitude: 51.4993, longitude: -0.1273), // Westminster Abbey
        Visit(arrivalDate: date(2025, 9, 21, 19, 30), departureDate: date(2025, 9, 21, 20, 30), latitude: 51.5074, longitude: -0.1657)  // Hyde Park
    ]

    // Day 3: 4 visits
    static let day3: [Visit] = [
        Visit(arrivalDate: date(2025, 9, 22, 8, 45),  departureDate: date(2025, 9, 22, 9, 45), latitude: 51.5096, longitude: -0.1960), // Notting Hill
        Visit(arrivalDate: date(2025, 9, 22, 11, 15), departureDate: date(2025, 9, 22, 12, 15), latitude: 51.5067, longitude: -0.1795), // Kensington Gardens
        Visit(arrivalDate: date(2025, 9, 22, 13, 45), departureDate: date(2025, 9, 22, 14, 45), latitude: 51.4967, longitude: -0.1764), // Natural History Museum
        Visit(arrivalDate: date(2025, 9, 22, 16, 15), departureDate: date(2025, 9, 22, 17, 15), latitude: 51.4875, longitude: -0.1680)  // Chelsea
    ]

    // Combined sample visits across the three days
    static let sampleVisits: [Visit] = day1 + day2 + day3

    // Insert all sample visits into the provided model context
    static func insertSampleData(modelContext: ModelContext) {
        for visit in sampleVisits {
            modelContext.insert(visit)
        }
    }
    
    // Delete existing Visit data and re-insert the sample visits
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Visit.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
