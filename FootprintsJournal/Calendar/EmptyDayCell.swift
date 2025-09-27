//
//  EmptyDayCell.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 19/09/2025.
//

import SwiftUI

struct EmptyDayCell: View {
    var body: some View {
        ZStack {
            // subtle background to show the square bounds
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemBackground))
            
        }
        .aspectRatio(1, contentMode: .fit) // keep each cell square
    }
}

#Preview {
    EmptyDayCell()
}
