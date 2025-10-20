//
//  DayCell.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 19/09/2025.
//

import SwiftUI

struct DayCell: View {
    
    let date: Date
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            // subtle background to show the square bounds
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemBackground))
            
            
            Text(date, format: .dateTime.day())
                .font(.headline)
                .foregroundStyle(.primary)
                .matchedGeometryEffect(
                    id: idForDate(date),
                    in: namespace
                )
            
        }
        .aspectRatio(1, contentMode: .fit) // keep each cell square
    }
    
    private func idForDate(_ date: Date) -> String {
        String(date.timeIntervalSinceReferenceDate)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    DayCell(date: Date.now, namespace: namespace)
}
