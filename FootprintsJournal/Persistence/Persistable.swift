//
//  Persistable.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 09/09/2025.
//

import Foundation

@MainActor
protocol Persistable {
    func save(_ location: Location)
    func save(_ visit: Visit)
    // add more as needed (delete, update, etc.)
}
