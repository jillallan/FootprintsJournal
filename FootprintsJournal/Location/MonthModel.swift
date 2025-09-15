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
    }
}

#Playground {
    
    let calendar = Calendar.current
    guard let month = calendar.date(byAdding: .month, value: -2, to: Date.now) else {
        return
    }
    month
    
    guard let firstOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: month)
    ) else { return }
    firstOfMonth
    
    guard let range = calendar.range(
        of: .day, in: .month, for: firstOfMonth
    ) else { return }
    range.count
    
    let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
    let leading = (firstWeekday - calendar.firstWeekday + 7) % 7
    
    let totalCells = leading + range.count
    let remainder = totalCells % 7
}
