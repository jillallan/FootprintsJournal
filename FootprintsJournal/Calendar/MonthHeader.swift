//
//  MonthHeader.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct MonthHeader: View {
    let title: String
    let weekdaySymbols: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            // Weekday labels row, Mon → Sun
            
            WeekdayHeaders(weekdaySymbols: weekdaySymbols)
//            Divider()
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
    }
}


#Preview {
    MonthHeader(title: "July 2025", weekdaySymbols: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
}
