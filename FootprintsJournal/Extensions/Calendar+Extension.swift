//
//  Calendar+Extension.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 04/09/2025.
//

import Foundation
import Playgrounds

//extension Calendar {
//    static func Date(year: Int, month: Int, day: Int) -> Date? {
//        var dateComponents = DateComponents()
//        dateComponents.year = year
//        dateComponents.month = month
//        dateComponents.day = day
//        return self.date(from: dateComponents)
//    }
//}

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        var components = dateComponents([.year, .month], from: date)
        components.day = 1
        return self.date(from: components)!
    }
    
    /// Adds month offset to the start-of-month anchor.
    func month(byAdding months: Int, toMonthOf date: Date) -> Date {
        let start = startOfMonth(for: date)
        return self.date(byAdding: .month, value: months, to: start)!
    }
    
    /// Returns the week number for a date, assuming the week starts on Monday
    func weekNumber(for date: Date) -> Int {
        var calendar = self
        calendar.firstWeekday = 2 // Monday
        return calendar.component(.weekOfYear, from: date)
    }
    
    static func generateMonths(around date: Date, monthsBefore: Int, monthsAfter: Int) -> [Date] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: date)
        components.day = 1
        components.timeZone = .gmt
        let startMonth = calendar.date(from: components)!
//        print(calendar.startOfMonth(for: date))
//        let startMonth = calendar.date(
//            byAdding: .month,
//            value: -monthsBefore,
//            to: calendar.startOfMonth(for: date)
//        )!
        print("startMonth: \(startMonth)")
        let dates = (0..<(monthsBefore + monthsAfter + 1)).compactMap {
            calendar.date(byAdding: .month, value: $0, to: startMonth)
        }
        print("Dates: \(dates)")
        return dates
    }
}

extension Calendar {
    func isDate(_ date: Date, withinMonths months: Int, of upper: Date) -> Bool {
        let startDate = startOfMonth(for: date)
        let startUpper = startOfMonth(for: upper)
        let diff = dateComponents([.month], from: startDate, to: startUpper).month
        guard let m = diff else { return false }
        return (0...months).contains(m)
    }
    
    /// Returns true if `date` is within `months` months after (or equal to) the lower bound month.
    /// Symmetric to `isDate(_:withinMonths:of:)` which checks against an upper bound.
    func isDate(_ date: Date, withinMonths months: Int, from lower: Date) -> Bool {
        let startLower = startOfMonth(for: lower)
        let startDate = startOfMonth(for: date)
        let diff = dateComponents([.month], from: startLower, to: startDate).month
        guard let m = diff else { return false }
        return (0...months).contains(m)
    }
   
}
