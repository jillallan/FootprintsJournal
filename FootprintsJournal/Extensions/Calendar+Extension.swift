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

