////  CalendarView.swift
////  FootprintsJournal
////
////  Created by Assistant on 12/09/2025.
////
//
//import SwiftUI
//
//struct CalendarViewOld: View {
//    @State private var scrollProxy: ScrollViewProxy? = nil
//    private let calendar: Calendar = {
//        var cal = Calendar.current
//        cal.firstWeekday = 2 // Monday is 2 in Apple's Calendar
//        return cal
//    }()
//    private let today = Date()
//    private let months: [Date] = Calendar.generateMonths(around: Date(), monthsBefore: 12, monthsAfter: 12)
//    
//    var body: some View {
//        ScrollViewReader { proxy in
//            ScrollView {
//                VStack(alignment: .leading, spacing: 0) {
//                    HStack(spacing: 4) {
//                        ForEach(
//                            CalendarViewOld.daySymbols(from: calendar),
//                            id: \.self
//                        ) { day in
//                            Text(day)
//                                .font(.caption)
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                    .padding(.bottom, 4)
//                    
//                    LazyVStack(alignment: .leading, spacing: 24) {
//                        ForEach(months, id: \.self) { month in
//                            Section(
//                                header: Text(
//                                    CalendarViewOld.monthYearString(from: month)
//                                )
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .padding(.vertical, 4)
//                            ) {
//                                ForEach(
//                                    CalendarViewOld.weeksInMonth(for: month, calendar: calendar),
//                                    id: \.self
//                                ) { week in
//                                    HStack(spacing: 4) {
//                                        ForEach(week, id: \.self) { date in
//                                            DayCell(date: date, isToday: calendar.isDate(date, inSameDayAs: today))
//                                        }
//                                    }
//                                }
//                            }
//                            .id(CalendarViewOld.idForMonth(month))
//                        }
//                    }
//                    .padding(.top, 8)
//                }
//                .padding()
//            }
//            .onAppear {
//                scrollProxy = proxy
//                // Scroll to current month on appear
//                let currentMonthId = CalendarViewOld.idForMonth(
//                    calendar.startOfMonth(for: today)
//                )
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    proxy.scrollTo(currentMonthId, anchor: .center)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    CalendarViewOld()
//}
//
//private struct DayCell: View {
//    let date: Date
//    let isToday: Bool
//    private let calendar = Calendar.current
//    var body: some View {
//        VStack {
//            Text("\(calendar.component(.day, from: date))")
//                .fontWeight(isToday ? .bold : .regular)
//                .foregroundColor(isToday ? .white : .primary)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(isToday ? Color.accentColor : Color.clear)
//                )
//        }
//        .frame(width: 36, height: 36)
//        .border(Color.secondary, width: 1)
//        
//    }
//}
//
//extension CalendarViewOld {
//    
//    
//    
//    // Get all weeks in a month, each as an array of 7 dates (may include days from previous/next month)
//    static func weeksInMonth(for month: Date, calendar: Calendar) -> [[Date]] {
//        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
//        var weeks: [[Date]] = []
//        // Start of the first week containing the first day of the month - aligned with calendar.firstWeekday (Monday)
//        var weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthInterval.start))!
//        // Adjust weekStart backwards if needed to align with firstWeekday (Monday)
//        let weekday = calendar.component(.weekday, from: weekStart)
//        let difference = (weekday >= calendar.firstWeekday) ?
//        weekday - calendar.firstWeekday :
//        7 - (calendar.firstWeekday - weekday)
//        if difference != 0 {
//            weekStart = calendar.date(byAdding: .day, value: -difference, to: weekStart)!
//        }
//        
//        repeat {
//            var week: [Date] = []
//            for i in 0..<7 {
//                if let day = calendar.date(byAdding: .day, value: i, to: weekStart) {
//                    week.append(day)
//                }
//            }
//            weeks.append(week)
//            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart) {
//                weekStart = nextWeek
//            } else {
//                break
//            }
//        } while weekStart < monthInterval.end
//        return weeks
//    }
//    
//    // Month-Year string (e.g., September 2025)
//    static func monthYearString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "LLLL yyyy"
//        return formatter.string(from: date)
//    }
//    // Generate a unique id for each month for scrolling
//    static func idForMonth(_ month: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM"
//        return formatter.string(from: month)
//    }
//    
//    static func daySymbols(from calendar: Calendar) -> [String] {
//        let symbols = calendar.shortStandaloneWeekdaySymbols
//        // Shift so Monday is first
//        return Array(symbols[calendar.firstWeekday-1..<symbols.count]) + symbols[0..<calendar.firstWeekday-1]
//    }
//}
