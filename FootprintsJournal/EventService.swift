//
//  EventService.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import EventKit
import Foundation
import Playgrounds

struct EventService {
    var store = EKEventStore()
    
    init() {
        store.requestFullAccessToEvents { granted, error in
            if granted {
                print("Access granted")
            } else {
                print("Access denied")
            }
        }
    }
    
    func getEvents(for dateInterval: DateInterval) -> [EKEvent] {
        let predicate = store.predicateForEvents(withStart: dateInterval.start, end: dateInterval.end, calendars: nil)
        let events = store.events(matching: predicate)
        return events
    }
}


#Playground {
    let eventService = EventService()
    let calendar = Calendar.current
    
    // Create the start date components
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date.now)
    dateComponents.month = calendar.component(.month, from: Date.now)
    dateComponents.day = calendar.component(.day, from: Date.now)
    let date = calendar.date(from: dateComponents)
    if let date {
        let dateInterval = DateInterval(start: date, duration: 86400)
        let events = eventService.getEvents(for: dateInterval)
        let eventMap = events.map { event in
            Event(
                title: event.title,
                location: event.location ?? "No location",
                startDate: event.startDate,
                endDate: event.endDate,
                isAllDay: event.isAllDay
            )
        }
        eventMap
    }
}
