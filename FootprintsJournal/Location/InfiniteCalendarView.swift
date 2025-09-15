//
//  InfiniteScrollView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct InfiniteCalendarView: View {
    private let baseDate: Date = Date.now
    // Sliding window of month offsets (e.g., -18...+18)
    @State private var monthWindow: ClosedRange<Int>
    @State private var anchorMonth: Int? // scroll anchor (offset id)
    
    private let chunkSize = 12         // grow by 12 months per edge reach
    private let keepAround = 36        // keep +/- 18 months total
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        cal.minimumDaysInFirstWeek = 4
        return cal
    }()
    
    private let formatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = .autoupdatingCurrent
        df.dateFormat = "LLLL yyyy"
        return df
    }()

    
    // MARK: Init
    init() {
        let half = 18
        _monthWindow = .init(initialValue: (-half)...(+half))
        _anchorMonth = .init(initialValue: 18)
        
    }
    
    public var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                    ForEach(Array(monthWindow), id: \.self) { monthOffset in
                        Section {
                            MonthGrid(
                                month: monthDate(for: monthOffset),
                                calendar: calendar
                            )
                        } header: {
                            MonthHeader(
                                title: formatter
                                    .string(from: monthDate(for: monthOffset)),
                                weekdaySymbols: weekdaySymbols()
                            )
                            .background(.thinMaterial) // pinned header backdrop
                        }
                        
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 24)
                }
            }
            // Keep the scroll position stable when trimming/expanding
            .scrollPosition(id: $anchorMonth)
            .task {
                // Small delay to let layout settle before anchoring
                try? await Task.sleep(nanoseconds: 50_000_000)
                anchorMonth = 0
            }
            .navigationTitle("Calendar")
        }
    }
}

extension InfiniteCalendarView {
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
    
    func monthDate(for offset: Int) -> Date {
        calendar
            .date(
                byAdding: .month,
                value: offset,
                to: firstOfMonth(for: baseDate)
            ) ?? baseDate
    }
    
    func firstOfMonth(for date: Date) -> Date {
        calendar
            .date(
                from: calendar.dateComponents([.year, .month], from: date)
            ) ?? baseDate
    }
    
    func headerID(for offset: Int) -> Int { offset }
    
    func weekdaySymbols() -> [String] {
        // Short standalone symbols, rotated so Monday is first.
        let fmt = DateFormatter()
        let symbols = fmt.shortStandaloneWeekdaySymbols ?? fmt.shortWeekdaySymbols ?? ["S","M","T","W","T","F","S"]
        let shift = (calendar.firstWeekday - 1) % 7
        return Array(symbols[shift...] + symbols[..<shift])
    }
    
    @MainActor
    func handleAppear(of offset: Int) {
        // When we approach either edge, expand by chunk
        let lower = monthWindow.lowerBound
        let upper = monthWindow.upperBound
        
        // Near top?
        if offset <= lower + 2 {
            expandLower()
        }
        // Near bottom?
        if offset >= upper - 2 {
            expandUpper()
        }
    }
    
    @MainActor
    func expandLower() {
        let newLower = monthWindow.lowerBound - chunkSize
        let newUpper = monthWindow.upperBound
        
        // Trim top if we exceed keepAround
        let desired = (newLower...newUpper)
        if desired.count > keepAround {
            let delta = desired.count - keepAround
            let trimmedLower = newLower
            let trimmedUpper = newUpper - delta
            monthWindow = trimmedLower...trimmedUpper
            // Keep the *visual* anchor by pinning to a close-by header id
            anchorMonth = max(trimmedLower + 2, min(anchorMonth ?? 0, trimmedUpper - 2))
        } else {
            monthWindow = newLower...newUpper
        }
    }
    
    @MainActor
    func expandUpper() {
        let newLower = monthWindow.lowerBound
        var newUpper = monthWindow.upperBound + chunkSize
        
        // Trim bottom if we exceed keepAround
        let desired = (newLower...newUpper)
        if desired.count > keepAround {
            let delta = desired.count - keepAround
            let trimmedLower = newLower + delta
            let trimmedUpper = newUpper
            monthWindow = trimmedLower...trimmedUpper
            anchorMonth = min(trimmedUpper - 2, max(anchorMonth ?? 0, trimmedLower + 2))
        } else {
            monthWindow = newLower...newUpper
        }
    }
}

#Preview {
    InfiniteCalendarView()
}
