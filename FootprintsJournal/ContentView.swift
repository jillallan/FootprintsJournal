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
    @State private var selectedTab: Int = 3
    let eventService = EventService()
    
//    private var locationService: LocationService {
//        // Grab the container from the current context
//        let container = modelContext.container
//        let repo = PersistenceController(modelContainer: container)
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
            Tab("Calendar", systemImage: "map", value: 4) {
                CalendarView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .modifier(SampleData())) {
    ContentView()
        .modelContainer(
            for: [Entry.self, Location.self, Visit.self],
            inMemory: true
        )
}
