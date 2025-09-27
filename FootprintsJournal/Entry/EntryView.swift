//
//  EntryView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import SwiftData
import SwiftUI

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [Entry]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        EntryDetail(entry: entry)
                    } label: {
                        EntryRow(entry: entry)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Entries")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Entry", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                if entries.count == 0 {
                    Entry.insertSampleData(modelContext: modelContext)
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newEntry = Entry(title: "A new entry", content: "Today I ...", timestamp: Date.now)
            modelContext.insert(newEntry)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(entries[index])
            }
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    EntryView()
}
