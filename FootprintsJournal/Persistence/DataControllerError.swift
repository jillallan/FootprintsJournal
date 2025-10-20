//
//  DataControllerError.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import Foundation

enum DataControllerError: Error {
    case locationSaveError
    case unknown
}

extension DataControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .locationSaveError:
                return NSLocalizedString(
                    "There was an error saving the location",
                    comment: "location save error"
                )
            case .unknown:
                return NSLocalizedString(
                    "An unknown error occured.",
                    comment: "Unknown error"
                )
        }
    }
}
