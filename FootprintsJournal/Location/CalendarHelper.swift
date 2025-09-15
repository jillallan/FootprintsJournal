//
//  CalendarHelper.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 14/09/2025.
//

import Foundation

struct CalendarHelper {
    static func weeksInMonth(for month: Date, calendar: Calendar) -> [[Date]] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        var weeks: [[Date]] = []
        // Start of the first week containing the first day of the month - aligned with calendar.firstWeekday (Monday)
        var weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthInterval.start))!
        // Adjust weekStart backwards if needed to align with firstWeekday (Monday)
        let weekday = calendar.component(.weekday, from: weekStart)
        let difference = (weekday >= calendar.firstWeekday) ?
        weekday - calendar.firstWeekday :
        7 - (calendar.firstWeekday - weekday)
        if difference != 0 {
            weekStart = calendar.date(byAdding: .day, value: -difference, to: weekStart)!
        }
        
        repeat {
            var week: [Date] = []
            for i in 0..<7 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekStart) {
                    week.append(day)
                }
            }
            weeks.append(week)
            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart) {
                weekStart = nextWeek
            } else {
                break
            }
        } while weekStart < monthInterval.end
        return weeks
    }
}
