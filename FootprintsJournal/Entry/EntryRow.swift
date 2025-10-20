//
//  EntryRow.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 16/09/2025.
//

import SwiftUI

struct EntryRow: View {
    @Bindable var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
            Text(entry.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.content)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    EntryRow(entry: .sample1)
}
