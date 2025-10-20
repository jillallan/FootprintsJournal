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
    @Binding var currentDate: Date
    @Binding var isShowingDayView: Bool
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Visit.arrivalDate) private var visits: [Visit]
    let dayNamespace: Namespace.ID
    
    var body: some View {
        NavigationStack {
            let _ = print("DayView initialized")
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
                        isShowingDayView = false
                        //                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "map")
                    }
                }
            }
            .toolbarVisibility(.hidden, for: .tabBar)
        }
    }
    
    init(
        currentDate: Binding<Date>,
        isShowingDayView: Binding<Bool>,
        dayNamespace: Namespace.ID
    ) {
        self._currentDate = currentDate
        self._isShowingDayView = isShowingDayView
        self.dayNamespace = dayNamespace
//        self.namespace = namespace
        let startDate = Calendar.current.startOfDay(
            for: currentDate.wrappedValue
        )
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
//        DayView(currentDate: .constant(date), isShowingDayView: .constant(true))
    }
}
