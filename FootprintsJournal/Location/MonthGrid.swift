//
//  MonthGridNew.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct MonthGrid: View {
    let month: Date
    let calendar: Calendar

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 7)
    }

    struct DaySlot: Identifiable {
        enum Kind { case blank, day(Int) }
        let id: Int           // unique within this month’s grid
        let kind: Kind
    }

    var body: some View {
        let model = MonthModel(month: month, calendar: calendar)

        // Build a single flat list of slots with stable, unique IDs
        let totalCells = model.leadingBlanks + model.numberOfDays + model.trailingBlanks
        let slots: [DaySlot] = (0..<totalCells).map { index in
            if index < model.leadingBlanks {
                return DaySlot(id: index, kind: .blank)
            }
            let dayIndex = index - model.leadingBlanks
            if dayIndex < model.numberOfDays {
                return DaySlot(id: index, kind: .day(dayIndex + 1))
            }
            return DaySlot(id: index, kind: .blank)
        }

        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(slots) { slot in
                switch slot.kind {
                case .blank:
                    DayCell(content: .blank)
                case .day(let n):
//                    DayCell(content: .dayNumber(n))
                        let dayDate = calendar.date(from: DateComponents(
                            year: calendar.component(.year, from: month),
                            month: calendar.component(.month, from: month),
                            day: n
                        ))!
                        
                        NavigationLink(value: dayDate) {
                            DayCell(content: .dayNumber(n))
                        }
                        .buttonStyle(.plain)
                }
            }
            
        }
        .navigationDestination(for: Date.self) { date in
            Text(date, style: .date)
        }
    }
}


#Preview {
    let calendar = Calendar.current
    if let month = calendar.date(byAdding: .month, value: -2, to: Date.now) {
        MonthGrid(month: month, calendar: calendar)
    }
}
