//
//  CalendarMonth.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 27/09/2025.
//

import Foundation

struct CalendarMonth {
    let date: Date
    let days: [CalendarDay]
    
    init(date: Date, calendar: Calendar) {
        self.date = date
        let firstOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: date)
        ) ?? Date()
        let range = calendar.range(
            of: .day,
            in: .month,
            for: firstOfMonth
        )
        let numberOfDays = range?.count ?? 30
        
        // Weekday of first day (1=Sunday ... 7=Saturday in Gregorian),
        // but we align relative to calendar.firstWeekday (which we set to Monday).
        let firstWeekday = calendar.component(
            .weekday,
            from: firstOfMonth
        )
        let leading = (firstWeekday - calendar.firstWeekday + 7) % 7
        let leadingBlanks = leading
        
        let totalCells = leadingBlanks + numberOfDays
        let remainder = totalCells % 7
        let trailingBlanks = remainder == 0 ? 0 : 7 - remainder
        
        // Build the sequential dates for the month
        let monthDates: [Date?] = (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: firstOfMonth)
        }
        
        // Combine leading blanks + dates + trailing blanks
        let dates = Array(repeating: nil, count: leadingBlanks)
            + monthDates
            + Array(repeating: nil, count: trailingBlanks)
        
        // After you've set `self.dates = ...`
        self.days = dates.enumerated().map { index, date in
            CalendarDay(id: index, date: date) // date is Date? so nils are preserved
        }
    }
}
