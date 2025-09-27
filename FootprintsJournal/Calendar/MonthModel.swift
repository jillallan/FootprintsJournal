//
//  MonthModel.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import Foundation
import Playgrounds

struct MonthModel {
    let numberOfDays: Int
    let leadingBlanks: Int
    let trailingBlanks: Int
    let dates: [Date?]
    let days: [DayObject]
    
    init(month: Date, calendar: Calendar) {
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        self.numberOfDays = range.count
        
        // Weekday of first day (1=Sunday ... 7=Saturday in Gregorian),
        // but we align relative to calendar.firstWeekday (which we set to Monday).
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let leading = (firstWeekday - calendar.firstWeekday + 7) % 7
        self.leadingBlanks = leading
        
        let totalCells = leadingBlanks + numberOfDays
        let remainder = totalCells % 7
        self.trailingBlanks = remainder == 0 ? 0 : 7 - remainder
        
        // Build the sequential dates for the month
        let monthDates: [Date?] = (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: firstOfMonth)
        }

        // Combine leading blanks + dates + trailing blanks
        self.dates = Array(repeating: nil, count: leadingBlanks)
            + monthDates
            + Array(repeating: nil, count: trailingBlanks)
        
        // After you've set `self.dates = ...`
        self.days = self.dates.enumerated().map { index, date in
            DayObject(id: index, date: date) // date is Date? so nils are preserved
        }
        
    }
}

#Playground {
    let month = MonthModel(month: Date(), calendar: .current)
    month.dates
    
    month.dates.enumerated().forEach { index, date in
        print("\(index): \(String(describing: date))")
    }
}
