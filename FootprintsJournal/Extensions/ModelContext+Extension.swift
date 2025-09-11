//
//  ModelContext+Extension.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 11/09/2025.
//

import Foundation
import SwiftData

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
