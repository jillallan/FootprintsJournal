//
//  MonthView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import SwiftUI

struct MonthView: View {
    let month: Date
    @State var numberOfRows: Int = 0
    @State var dates: [Date?] = []
   
    
    var body: some View {
        Grid {
            ForEach(0..<numberOfRows, id: \.self) { row in
                GridRow {
                    ForEach(0..<7) { cell in
                        CalendarDayCell()
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            if let weekCount = numberOfWeeks(in: month) {
                numberOfRows = weekCount
            }
            
            let weekDayStart = month.weekday
            
            
            
            
            if let tempDate = Calendar.current.date(byAdding: .month, value: 1, to: month) {
                if let endDate = Calendar.current.date(
                    byAdding: .day,
                    value: -1,
                    to: tempDate
                ) {
                    let tempDates = dateRange(from: month, to: endDate)
                    dates = padStartWithNil(tempDates, count: weekDayStart - 1)
                    print(dates)
                }
                
            }
            
        }
    }
    
    func padStartWithNil<T>(_ array: [T?], count: Int) -> [T?] {
        Array(repeating: nil, count: count) + array
    }
    
    func dateRange(from start: Date, to end: Date, stepDays: Int = 1, calendar: Calendar = .current) -> [Date] {
        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            guard let next = calendar.date(byAdding: .day, value: stepDays, to: current) else { break }
            current = next
        }
        return dates
    }
    

    
    
    
    func numberOfWeeks(in month: Date, calendar: Calendar = .current) -> Int? {
        // Get the range for the current month
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let startWeek = calendar.dateComponents([.weekOfYear], from: monthInterval.start).weekOfYear,
            let endWeek = calendar.dateComponents([.weekOfYear], from: monthInterval.end.addingTimeInterval(-1)).weekOfYear
                
        else {
            return nil
        }
        
//        print("For date: \(month), monthInterval: \(monthInterval), startWeek: \(startWeek), endWeek: \(endWeek)")
        
        // Handle year transition (e.g., December -> January)
        let numberOfWeeks: Int
        if endWeek < startWeek {
            // This means the month spans the new year
            let weeksInYear = calendar.range(of: .weekOfYear, in: .yearForWeekOfYear, for: month)?.count ?? 52
            numberOfWeeks = (weeksInYear - startWeek + 1) + endWeek
        } else {
            numberOfWeeks = endWeek - startWeek + 1
        }
        
        return numberOfWeeks
    }
}

#Preview {
    MonthView(month: Date.now)
}
