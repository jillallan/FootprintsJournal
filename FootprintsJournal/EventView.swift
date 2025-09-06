//
//  EventView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 04/09/2025.
//

import SwiftUI

struct EventView: View {
    @State var eventService = EventService()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(eventService.events) { event in
                    Text(event.title)
                }
            }.navigationTitle("Events")
        }
        .onAppear {
            Task {
                _ = try await eventService.verifyAuthorizationStatus()
                let date = Date.now
                let interval = DateInterval(start: date, duration: 86400*30)
                _ = eventService.getEvents(from: eventService.eventStore, for: interval)
            }
            
        }
    }
}

#Preview {
    EventView()
}
