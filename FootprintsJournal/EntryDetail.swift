//
//  EntryDetail.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import SwiftUI

struct EntryDetail: View {
    @Bindable var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(entry.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(entry.timestamp, format: Date.FormatStyle(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            Text(entry.content)
                .font(.body)
            Spacer()
        }
        .padding()
    }
}

#Preview(traits: .modifier(SampleData())) {
    EntryDetail(entry: .sample1)
}
