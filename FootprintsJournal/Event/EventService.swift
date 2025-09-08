//
//  EventService.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import EventKit
import Foundation
import Observation
import Playgrounds

@Observable
class EventService {
    var events: [Event] = []
    @ObservationIgnored
    var eventStore: any EventStoreProtocol

    init(eventStore: any EventStoreProtocol = EKEventStore()) {
        self.eventStore = eventStore
    }
    
    var isFullAccessAuthorized: Bool {
        type(of: eventStore).authorizationStatus(for: .event) == .fullAccess
    }

    /// Prompts the user for full-access authorization to Calendar.
    private func requestFullAccess() async throws -> Bool {
        return try await eventStore.requestFullAccessToEvents()
    }
    
    /// Verifies the authorization status for the app.
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = type(of: eventStore).authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            return try await requestFullAccess()
        case .restricted:
            throw EventStoreError.restricted
        case .denied:
            throw EventStoreError.denied
        case .fullAccess:
            return true
        case .writeOnly:
            throw EventStoreError.upgrade
        @unknown default:
            throw EventStoreError.unknown
        }
    }
    
    func getEvents(from store: any EventStoreProtocol, for dateInterval: DateInterval) -> [Event] {
        
        guard isFullAccessAuthorized else { return [] }
        
        let predicate = store.predicateForEvents(withStart: dateInterval.start, end: dateInterval.end, calendars: nil)
        let eventsArray = store.events(matching: predicate).map { event in
            Event(title: event.title, location: event.location ?? "No location", startDate: event.startDate, endDate: event.endDate, isAllDay: event.isAllDay)
        }
        events = eventsArray.sorted { $0.startDate < $1.startDate }
        return events
    }
}

protocol EventStoreProtocol {
    func requestFullAccessToEvents() async throws -> Bool
    static func authorizationStatus(
        for entityType: EKEntityType
    ) -> EKAuthorizationStatus
    func events(matching predicate: NSPredicate) -> [EKEvent]
    func predicateForEvents(
        withStart startDate: Date,
        end endDate: Date,
        calendars: [EKCalendar]?
    ) -> NSPredicate
    func save(_ event: EKEvent, span: EKSpan, commit: Bool) throws
}

extension EKEventStore: EventStoreProtocol { }


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
        let events = eventService.getEvents(from: eventService.eventStore, for: dateInterval)
        print(events)
    }
}
