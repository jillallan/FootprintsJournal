//
//  Entry.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var title: String
    var content: String
    var timestamp: Date
    
    init(title: String, content: String, timestamp: Date) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}
