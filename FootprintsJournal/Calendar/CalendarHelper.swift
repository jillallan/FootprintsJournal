//
//  CalendarHelper.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 14/09/2025.
//

import Foundation

struct CalendarHelper {
    static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
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
}
