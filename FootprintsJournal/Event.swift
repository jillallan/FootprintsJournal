//
//  Event.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
}
