//
//  CalendarDetail.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 27/09/2025.
//

import SwiftUI

struct CalendarDetail: View {
    @State var selectedDate: Date
    @State private var isShowingDayView = false
    @State var scrollPosition: Date?
    @State private var months: [CalendarMonth] = []
    private let chunkSize = 12         // grow by 12 months per edge reach
    private let keepAround = 36        // keep +/- 18 months total
    
    @Namespace private var dayNamespace
    @Namespace private var monthNamespace
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        cal.minimumDaysInFirstWeek = 4
        return cal
    }()
    
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 7)
    }
    
    init(currentDate: Date) {
        let calendar = Calendar.current
        let currentMonthId = calendar.startOfMonth(for: currentDate)
        _scrollPosition = State(wrappedValue: currentMonthId)
        
        let half = 18
        let months: [CalendarMonth] = (-half...half).map { offset in
            let month = calendar.month(byAdding: offset, toMonthOf: currentMonthId)
            return CalendarMonth(date: month, calendar: calendar)
        }
        
        _months = State(wrappedValue: months)
        _selectedDate = State(wrappedValue: currentDate)
    }
    
    var body: some View {
        VStack {
            WeekdayHeaders(weekdaySymbols: weekdaySymbols())
                .font(.largeTitle)
            ScrollView {
                LazyVStack {
                    ForEach(months, id: \.date) { month in
                        MonthGrid(
                            selectedDate: $selectedDate,
                            isShowingDayView: $isShowingDayView,
                            month: month,
                            calendar: calendar,
                            dayNamespace: dayNamespace,
                            monthNamespace: monthNamespace
                        )
                        .onAppear {
                            handleAppear(of: month.date)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)                 // <- add this
            .scrollPosition(id: $scrollPosition, anchor: .top)
            
        }

        .onChange(of: isShowingDayView) {
            if !isShowingDayView {
                focus(on: selectedDate) // scroll to the right month
            }
        }
        .onAppear {
            focus(on: selectedDate, animated: false) // uses your existing method
        }
        .overlay {
            if isShowingDayView {
                DateDetailView(
                    date: selectedDate,
                    dayNamespace: dayNamespace,
                    monthNamespace: monthNamespace,
                    matchedID: selectedDate.id,
                    monthID: calendar.startOfMonth(for: selectedDate).id,
                    onClose: {
                        withAnimation(.spring(duration: 2.0)) {
                            isShowingDayView = false
                        }
                    }
                )
            }
        }
    }
    
    private func idForDate(_ date: Date) -> String {
        String(date.timeIntervalSinceReferenceDate)
    }
    
    private func dayID(_ date: Date, calendar: Calendar) -> DateComponents {
//        calendar.startOfDay(for: date)
        calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    @MainActor
    func focus(on date: Date, animated: Bool = true) {
        let targetMonth = calendar.startOfMonth(for: date)
        ensureMonthVisible(for: targetMonth) // make sure it's loaded
    
        // Defer to next runloop and force a re-scroll

        if animated {
            withAnimation(.snappy) { scrollPosition = targetMonth }
        } else {
            scrollPosition = targetMonth
        }
    }
    
    @MainActor
    func ensureMonthVisible(for month: Date) {
        guard let lower = months.first?.date, let upper = months.last?.date else { return }
        
        if month < lower {
            let diff = calendar.dateComponents([.month], from: month, to: lower).month ?? 0
            let chunks = (diff / chunkSize) + 1
            for _ in 0..<chunks { expandLower() }
        } else if month > upper {
            let diff = calendar.dateComponents([.month], from: upper, to: month).month ?? 0
            let chunks = (diff / chunkSize) + 1
            for _ in 0..<chunks { expandUpper() }
        }
        
        // Optional: trim memory if you like
        trimAround(center: month)
    }
    
    @MainActor
    func trimAround(center: Date) {
        // Keep +/- keepAround/2 months around the center
        let half = keepAround / 2
        let start = calendar.startOfMonth(for: center)
        let lowerBound = calendar.month(byAdding: -half, toMonthOf: start)
        let upperBound = calendar.month(byAdding:  half, toMonthOf: start)
        
        months.removeAll { $0.date < lowerBound || $0.date > upperBound }
    }
    
    func weekdaySymbols() -> [String] {
        // Short standalone symbols, rotated so Monday is first.
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let shift = (calendar.firstWeekday - 1) % 7
        return Array(symbols[shift...] + symbols[..<shift])
    }
    
    @MainActor
    func handleAppear(of offset: Date) {
        let calendar = Calendar.current
        
        // When we approach either edge, expand by chunk
        guard let lower = months.first?.date else { return }
        guard let upper = months.last?.date else { return }
        
        var didExpand = false
        
        if calendar.isDate(offset, withinMonths: 2, of: upper) {
            expandUpper()
            didExpand = true
        }
        
        if calendar.isDate(offset, withinMonths: 2, of: lower) {
            expandLower()
            didExpand = true
        }
        
        // If we expanded, trim around the month that just appeared
        if didExpand {
            let center = calendar.startOfMonth(for: offset)
            trimAround(center: center)
        }
    }
    
    @MainActor
    func expandUpper() {
        let calendar = Calendar.current
        
        // Normalize to month starts to avoid issues with different month lengths
        guard let lastMonth = months.last?.date else { return }
        let start = calendar.startOfMonth(for: lastMonth)
        
        // If you have your helper available:
        let toAppend = (1...chunkSize).map { offset in
            let date = calendar.month(byAdding: offset, toMonthOf: start)
//            print("New Date: \(date)")
            return CalendarMonth(date: date, calendar: calendar)
        }
        
        months.append(contentsOf: toAppend)
    }
    
    @MainActor
    func expandLower() {
        let calendar = Calendar.current
        
        // Normalize to month starts to avoid issues with different month lengths
        guard let firstMonth = months.first?.date else { return }
        let start = calendar.startOfMonth(for: firstMonth)
        
//        print("firstMonth: \(firstMonth)")
        
        let toPrepend = (1...chunkSize).reversed().map { offset in
            CalendarMonth(date: calendar.month(byAdding: -offset, toMonthOf: start), calendar: calendar)
        }
        months.insert(contentsOf: toPrepend, at: 0)
        // or: months = toPrepend + months
    }
}

#Preview {
    CalendarDetail(currentDate: Date())
}

