//
//  CalendarView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import SwiftUI

struct CalendarView: View {
    private let calendar: Calendar
    private let months: [Date]
    private let monthHeaderFormatter: DateFormatter
    private let weekdaySymbols: [String]
    
    // MARK: Init
    public init(start: Date, end: Date, calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2 // Monday
        cal.minimumDaysInFirstWeek = 4 // ISO-like
        return cal
    }()) {
        self.calendar = calendar
        self.months = CalendarView.monthsInRange(start: start, end: end, calendar: calendar)
        
        self.monthHeaderFormatter = DateFormatter()
        self.monthHeaderFormatter.calendar = calendar
        self.monthHeaderFormatter.locale = .autoupdatingCurrent
        self.monthHeaderFormatter.dateFormat = "LLLL yyyy"
        
        // Weekday symbols aligned to Monday
        let symbols = DateFormatter().shortStandaloneWeekdaySymbols ?? DateFormatter().shortWeekdaySymbols
        let original = symbols ?? ["S","M","T","W","T","F","S"]
        let shift = (calendar.firstWeekday - 1) % 7 // 0-based
        self.weekdaySymbols = Array(original[shift...] + original[..<shift])
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                ForEach(months, id: \.self) { month in
                    Section {
                        MonthGrid(month: month, calendar: calendar)
                    } header: {
                        MonthHeader(
                            title: monthHeaderFormatter.string(from: month),
                            weekdaySymbols: weekdaySymbols
                        )
                        .background(.thinMaterial) // pinned header backdrop
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 24)
        }
    }
}

extension CalendarView {
    static func monthsInRange(
        start: Date, end: Date, calendar: Calendar
    ) -> [Date] {
        guard let startMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: start)
        ),
              let endMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: end)
              ),
              startMonth <= endMonth
        else { return [] }
        
        var months: [Date] = []
        var cursor = startMonth
        while cursor <= endMonth {
            months.append(cursor)
            cursor = calendar.date(byAdding: .month, value: 1, to: cursor)!
        }
        return months
    }
}

#Preview {
    if let startMonth = Calendar.current.date(
        byAdding: .month,
        value: -12,
        to: Date.now
    ),
       let endMonth = Calendar.current.date(
        byAdding: .month,
        value: 12,
        to: Date.now
       ) {
        CalendarView(start: startMonth, end: endMonth)
    }
}
