//
//  DayCell2.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 19/09/2025.
//

import SwiftUI

struct DayCell2: View {
    
    let date: Date
    
    var body: some View {
        ZStack {
            // subtle background to show the square bounds
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemBackground))
            
            
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
                .foregroundStyle(.primary)
            
        }
        .aspectRatio(1, contentMode: .fit) // keep each cell square
    }
}

#Preview {
    DayCell2(date: Date.now)
}
