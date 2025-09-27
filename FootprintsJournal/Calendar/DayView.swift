//
//  DayView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 19/09/2025.
//

import CoreLocation
import SwiftData
import SwiftUI

struct DayView: View {
    @Binding var selectedDate: Date?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Visit.arrivalDate) private var visits: [Visit]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(visits) { visit in
                    VisitRow(visit: visit)
                  
                }
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addLocation) {
                        Label("Add Visit", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedDate = nil
//                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "map")
                    }

                }
            }
            .toolbarVisibility(.hidden, for: .tabBar)
            .navigationTitle(
                selectedDate?
                    .formatted(date: .abbreviated, time: .omitted) ?? Date.now.formatted(date: .abbreviated, time: .omitted)
            )
        }
    }
    
    init(
        selectedDate: Binding<Date?>
    ) {
        self._selectedDate = selectedDate
        if let date = selectedDate.wrappedValue {
            let startDate = Calendar.current.startOfDay(for: date)
            let endDate = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: startDate
            )
            
            if let endDate {
                _visits = Query(filter: #Predicate { visit in
                    visit.arrivalDate >= startDate && visit.arrivalDate < endDate
                }, sort: \.arrivalDate)
            }
        }
    }
    
//    init(selectedDate: Date) {
//        self.selectedDate = selectedDate
//        let startDate = Calendar.current.startOfDay(for: selectedDate)
//        let endDate = Calendar.current.date(
//            byAdding: .day,
//            value: 1,
//            to: startDate
//        )
//        
//        if let endDate {
//            _locations = Query(filter: #Predicate { location in
//                location.timestamp >= startDate && location.timestamp < endDate
//            }, sort: \.timestamp)
//        }
//    }
}

extension DayView {
    private func addLocation() {
        withAnimation {
            let visit = Visit(
                arrivalDate: Date.now,
                departureDate: Date.now.addingTimeInterval(600),
                latitude: 51.5,
                longitude: 0.0
            )
            modelContext.insert(visit)
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    let date = CalendarHelper.date(2025, 9, 20, 13, 0)
    
    NavigationStack {
        DayView(selectedDate: .constant(date))
    }
}
