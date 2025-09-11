//
//  ContentView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Int = 0
    let eventService = EventService()
    
//    private var locationService: LocationService {
//        // Grab the container from the current context
//        let container = modelContext.container
//        let repo = Repository(modelContainer: container)
//        return LocationService(persister: repo)
//    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Journal", systemImage: "book", value: 0) {
                EntryView()
            }
            Tab("Events", systemImage: "calendar", value: 1) {
                EventView()
            }
            Tab("Locations", systemImage: "map", value: 2) {
                LocationView()
            }
            Tab("Visits", systemImage: "map", value: 3) {
                VisitView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .modifier(SampleData())) {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}
