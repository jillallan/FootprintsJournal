//
//  DayCell.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 15/09/2025.
//

import SwiftUI

struct DayCell: View {
    enum Content {
        case blank
        case dayNumber(Date)
    }
    
    let content: Content
    
    var body: some View {
        ZStack {
            // subtle background to show the square bounds
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.thinMaterial.opacity(0.15))
            
            switch content {
                case .blank:
                    // empty square to preserve grid alignment
                    EmptyView()
                case .dayNumber(let date):
                    Text(date.formatted(.dateTime.day()))
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.primary)
            }
        }
        .aspectRatio(1, contentMode: .fit) // keep each cell square
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.secondary.opacity(0.2), lineWidth: 0.5)
        )
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var accessibilityLabel: Text {
        switch content {
            case .blank: return Text("Empty")
            case .dayNumber(let date): return Text("Day \(date.formatted(.dateTime.day()))")
        }
    }
}

#Preview {
    DayCell(content: .dayNumber(Date.now))
}
