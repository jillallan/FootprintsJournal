//
//  MonthGridNew.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct MonthGrid: View {
    @Namespace var namespace
    @Binding var selectedDate: Date?
    let month: Date
    let calendar: Calendar
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 7)
    }
    
    var body: some View {
        let model = MonthModel(month: month, calendar: calendar)
        
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(model.days) { day in
                if let date = day.date {
                    Button {
                        selectedDate = date
                    } label: {
                        DayCell2(date: date)
                    }
                    .buttonStyle(.plain)
                } else {
                    EmptyDayCell()
                }
            }
        }
    }
}


#Preview {
    let calendar = Calendar.current
    if let month = calendar.date(byAdding: .month, value: -2, to: Date.now) {
        MonthGrid(
            selectedDate: .constant(nil),
            month: month,
            calendar: calendar
        )
    }
}
