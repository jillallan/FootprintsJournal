//
//  ContentView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Journal", systemImage: "book", value: 0) {
                EntryView()
            }
            Tab("Settings", systemImage: "gear", value: 1) {
                SettingsView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .modifier(SampleData())) {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}
