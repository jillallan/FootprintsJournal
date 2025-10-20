//
//  MonthGrid.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 28/09/2025.
//

import SwiftUI

struct MonthGrid: View {
    @Binding var selectedDate: Date
    @Binding var isShowingDayView: Bool
    let month: CalendarMonth
    let calendar: Calendar
    let dayNamespace: Namespace.ID
    let monthNamespace: Namespace.ID
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 7)
    }
    
    var body: some View {
        VStack {
            MonthHeader(
                date: calendar.startOfMonth(for: month.date),
                namespace: monthNamespace
            )
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(month.days) { day in
                    if let date = day.date {
                        Button {
                            withAnimation(.spring(duration: 0.5)) {
                                selectedDate = date
                                isShowingDayView = true
                            }
                        } label: {
                            DayCell(
                                date: date,
                                namespace: dayNamespace
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        EmptyDayCell()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var dayNamespace
    @Previewable @Namespace var monthNamespace
    
    MonthGrid(
        selectedDate: .constant(Date.now),
        isShowingDayView: .constant(true),
        month: CalendarMonth(date: Date.now, calendar: Calendar.current),
        calendar: Calendar.current,
        dayNamespace: dayNamespace,
        monthNamespace: monthNamespace
    )
}
