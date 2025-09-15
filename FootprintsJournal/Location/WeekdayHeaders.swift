//
//  WeekdayHeaders.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct WeekdayHeaders: View {
    let weekdaySymbols: [String]
    
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 24), spacing: 6), count: 7), spacing: 6) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol.uppercased())
                    .font(.caption2.weight(.medium))
                    .opacity(0.6)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
        .accessibilityHidden(true)
    }
}
