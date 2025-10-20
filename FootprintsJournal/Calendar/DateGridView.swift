//
//  DateGridView.swift
//  FootprintsJournal
//
//  Created by Assistant on 03/10/2025.
//

import SwiftUI

/// A reusable grid view that displays dates in a 7-column layout.
/// Each grid item shows the date using `Text(date, format: .shortened)`.
struct DateGridView: View {
    let dates: [Date]
    
    @Namespace private var dateNamespace
    @State private var selectedDate: Date? = nil
    @State private var showDetail: Bool = false

    private func idForDate(_ date: Date) -> String {
        String(date.timeIntervalSinceReferenceDate)
    }
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .top), count: 7)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(dates, id: \.timeIntervalSinceReferenceDate) { date in
                    Button {
                        withAnimation(.spring(duration: 2.0)) {
                            selectedDate = date
                            showDetail = true
                        }
        
                    } label: {
                        Text(date, format: .dateTime.day())
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.thinMaterial)
                            )
                            .matchedGeometryEffect(id: idForDate(date), in: dateNamespace)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .overlay(alignment: .top) {
            if let selectedDate, showDetail {
//                DateDetailView(
//                    date: selectedDate,
//                    namespace: dateNamespace,
//                    matchedID: idForDate(selectedDate),
//                    onClose: {
//
//                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2)) {
//                            showDetail = false
//                            // Delay clearing selectedDate until after animation to keep matchedGeometryEffect in sync
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                                self.selectedDate = nil
//                            }
//                        }
//                    }
//                )
//                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)),
//                                         removal: .opacity.combined(with: .move(edge: .top))))
            }
        }
        .navigationTitle("Dates")
    }
}

#Preview("7-Column Grid of 28 Days") {
    let calendar = Calendar.current
    let start = calendar.startOfDay(for: .now)
    let sample: [Date] = (0..<28).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    
    NavigationStack {
        DateGridView(dates: sample)
    }
}

