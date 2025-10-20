//
//  MonthGrid.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 28/09/2025.
//

import SwiftUI

struct MonthGrid2: View {
    @Binding var selectedDate: Date
    @State var isShowingDayView: Bool
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
                            withAnimation(.spring(duration: 2.0)) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .overlay {
            if isShowingDayView {
                DateDetailView(
                    date: selectedDate,
                    dayNamespace: dayNamespace,
                    monthNamespace: monthNamespace,
                    matchedID: selectedDate.id,
                    monthID:
                        calendar.startOfMonth(for: selectedDate).id
                    ) {
                        // TODO: -
                        withAnimation(.spring(duration: 2.0)) {
                            isShowingDayView = false
                        }
                    }
            }
        }
    }
}

#Preview("With overlay") {
    @Previewable @Namespace var dayNamespace
    @Previewable @Namespace var monthNamespace

    @Previewable @State var selectedDate = Date.now // <- dynamic in preview
    @Previewable @State var isShowingDayView = true

    MonthGrid2(
        selectedDate: $selectedDate,                 // <- pass binding
        isShowingDayView: isShowingDayView,          // you can also make this @Binding if desired
        month: CalendarMonth(date: selectedDate, calendar: .current),
        calendar: .current,
        dayNamespace: dayNamespace,
        monthNamespace: monthNamespace
    )
}

#Preview("Without overlay") {
    @Previewable @Namespace var dayNamespace
    @Previewable @Namespace var monthNamespace

    @Previewable @State var selectedDate = Date.now // <- dynamic in preview
    @Previewable @State var isShowingDayView = false

    MonthGrid2(
        selectedDate: $selectedDate,                 // <- pass binding
        isShowingDayView: isShowingDayView,
        month: CalendarMonth(date: selectedDate, calendar: .current),
        calendar: .current,
        dayNamespace: dayNamespace,
        monthNamespace: monthNamespace
    )
}
