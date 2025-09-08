//
//  LocationError.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 08/09/2025.
//

import Foundation

enum LocationError: Error {
    case denied
    case restricted
    case unknown
    case upgrade
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .denied:
                return NSLocalizedString("The app doesn't have permission to access location data. If you would like the app to use your location to generate entries got to \"Settings\" -> \"Privacy\" -> \"Location Services\" -> \"Footprints Journal\" to grant access", comment: "Access denied")
            case .restricted:
                return NSLocalizedString("This device doesn't allow access to Location data.", comment: "Access restricted")
            case .unknown:
                return NSLocalizedString("An unknown error occured.", comment: "Unknown error")
            case .upgrade:
                let access = "The app has in use access to Location data in Settings."
                let update = "Please grant it full access so the app can fetch and location data."
                return NSLocalizedString("\(access) \(update)", comment: "Upgrade to full access")
        }
    }
}
