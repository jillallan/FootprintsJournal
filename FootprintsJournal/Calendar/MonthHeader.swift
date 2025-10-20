//
//  MonthHeader.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct MonthHeader: View {
    let date: Date
    let namespace: Namespace.ID
    
    var body: some View {
        HStack {
            Text(date, format: .dateTime.month(.wide).year())
                .font(.title2)
                .matchedGeometryEffect(id: date.id, in: namespace)
    //            .padding(.top, 8)
            Spacer()
        }

    }
    
    private func idForDate(_ date: Date) -> String {
        String(date.timeIntervalSinceReferenceDate)
    }
}


#Preview {
    @Previewable @Namespace var namespace
    
    MonthHeader(
        date: Date.now,
        namespace: namespace
    )
}
