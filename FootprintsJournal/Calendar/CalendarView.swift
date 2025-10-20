//
//  CalendarView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 29/09/2025.
//

import SwiftUI

struct CalendarView: View {
    private let years: [Int] = Array(2024...2026)
    private let calendar = Calendar(identifier: .gregorian)

    var body: some View {
        NavigationStack {
            List {
                ForEach(years, id: \.self) { year in
                    Section {
                        ForEach(firstOfMonths(in: year), id: \.self) { date in
                            NavigationLink(value: date) {

                                Text(date, formatter: Self.MMMFormatter)
                            }
                        }
                    } header: {
                        Text(String(year))
                    }
                }
            }
            .navigationTitle("Calendar")
            .navigationDestination(for: Date.self) { date in
                // Placeholder destination; replace with your CalendarMonthView if desired
//                Text(date, formatter: Self.yyyyMMddFormatter)
                CalendarDetail(currentDate: date)
            }
        }
    }

    // Returns the first day of each month for the given year
    private func firstOfMonths(in year: Int) -> [Date] {
        (1...12).compactMap { month in
            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = 1
            return calendar.date(from: comps)
        }
    }

    // Formatter to display dates as yyyy/MM/dd (e.g., 2025/01/01)
    private static let MMMFormatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "MMM"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }()
}

#Preview {
    CalendarView()
}
