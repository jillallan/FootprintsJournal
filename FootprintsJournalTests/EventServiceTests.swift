import Testing
import EventKit
@testable import FootprintsJournal

@MainActor
class MockEventStore: EventStoreProtocol {
    var lastPredicate: NSPredicate?
    var savedEvents: [EKEvent] = []
    var testEvents: [EKEvent]
    var lastInterval: DateInterval?
    var authorisationStatus: EKAuthorizationStatus
    static var currentAuthorizationStatus: EKAuthorizationStatus = .fullAccess
    
    init(events: [EKEvent] = [],
         authorisationStatus: EKAuthorizationStatus = .fullAccess
    ) {
        self.testEvents = events
        self.authorisationStatus = authorisationStatus
        MockEventStore.currentAuthorizationStatus = authorisationStatus
    }
    
    func requestFullAccessToEvents() async throws -> Bool {
        return authorisationStatus == .fullAccess
    }

    class func authorizationStatus(
        for entityType: EKEntityType
    ) -> EKAuthorizationStatus {
        return currentAuthorizationStatus
    }
    
    func events(matching predicate: NSPredicate) -> [EKEvent] {
        lastPredicate = predicate
        
        guard let interval = lastInterval else { return testEvents }
        // Only return events within the interval
        return testEvents.filter { event in
            event.startDate >= interval.start && event.endDate <= interval.end
        }
    }
    
    func predicateForEvents(withStart startDate: Date, end endDate: Date, calendars: [EKCalendar]?) -> NSPredicate {
        self.lastInterval = DateInterval(start: startDate, end: endDate)
        return NSPredicate()
    }

    func save(_ event: EKEvent, span: EKSpan, commit: Bool) throws {
        savedEvents.append(event)
    }
}

@MainActor
@Suite("EventService", .serialized)
struct EventServiceTests {
    
    func createEventService(
        events: [EKEvent],
        authorizationStatus: EKAuthorizationStatus
    ) throws -> EventService {
        let mockEventStore = try createMockEventStore(
            events: events,
            authorizationStatus: authorizationStatus
        )
        let eventService = EventService(eventStore: mockEventStore)
        return eventService
    }
    
    func createMockEventStore(
        events: [EKEvent],
        authorizationStatus: EKAuthorizationStatus
    ) throws -> MockEventStore {
        let mockEventStore = MockEventStore(
            events: events,
            authorisationStatus: authorizationStatus
        )
        try #require(mockEventStore.authorisationStatus == authorizationStatus)
        try #require(mockEventStore.testEvents.count == events.count)
        
        return mockEventStore
    }
    
    func createEvent(store: EKEventStore, startDate: Date, endDate: Date) -> EKEvent {
        let event = EKEvent(eventStore: store)
        event.startDate = startDate
        event.endDate = endDate
        return event
    }
    
    @Test("EventService Authentication Status", arguments: [
        EKAuthorizationStatus.notDetermined,
        .denied,
        .restricted,
        .writeOnly
    ])
    func eventServiceStoreAuthenticationStatus(status: EKAuthorizationStatus) async throws {
        let eventStore = EKEventStore()
        let event = createEvent(
            store: eventStore,
            startDate: Date.now,
            endDate: Date.now.addingTimeInterval(300)
        )
        let eventService = try createEventService(
            events: [event],
            authorizationStatus: status
        )
        #expect(eventService.isFullAccessAuthorized == false, "Expected false for \(status)")
    }
    
    @Test("EventService Authentication Status FullAccess", arguments: [
        EKAuthorizationStatus.fullAccess
    ])
    func eventServiceStoreAuthenticationStatusFullAccess(status: EKAuthorizationStatus) async throws {
        let eventStore = EKEventStore()
        let event = createEvent(
            store: eventStore,
            startDate: Date.now,
            endDate: Date.now.addingTimeInterval(300)
        )
        let eventService = try createEventService(
            events: [event],
            authorizationStatus: status
        )
        #expect(eventService.isFullAccessAuthorized == true, "Expected true for \(status)")
    }
    
    @Test(
        "EventService Authentication Status Not FullAccess Returns empty array",
        arguments: [
            EKAuthorizationStatus.notDetermined,
            .denied,
            .restricted,
            .writeOnly
        ]
    )
    func eventServiceStoreAuthenticationStatusNotFullAccessReturnsEmptyArray(status: EKAuthorizationStatus) async throws {
        let eventStore = EKEventStore()
        let event = createEvent(
            store: eventStore,
            startDate: Date.now,
            endDate: Date.now.addingTimeInterval(300)
        )
        let eventService = try createEventService(
            events: [event],
            authorizationStatus: status
        )
        let events = eventService
            .getEvents(
                from: eventService.eventStore,
                for: DateInterval(start: Date.now.addingTimeInterval(-300), duration: 600)
            )
        #expect(events.count == 0, "Expected 0 events, got \(events.count)")
    }
    
    @Test(
        "EventService Authentication Status FullAccess Returns events",
        arguments: [
            EKAuthorizationStatus.fullAccess
        ]
    )
    func eventServiceStoreAuthenticationStatusFullAccessReturnsEvents(status: EKAuthorizationStatus) async throws {
        let eventStore = EKEventStore()
        let event = createEvent(
            store: eventStore,
            startDate: Date.now,
            endDate: Date.now.addingTimeInterval(300)
        )
        let eventService = try createEventService(
            events: [event],
            authorizationStatus: status
        )
        let events = eventService
            .getEvents(
                from: eventService.eventStore,
                for: DateInterval(start: Date.now.addingTimeInterval(-300), duration: 600)
            )
        #expect(events.count == 1, "Expected 1 events, got \(events.count)")
    }
    
    @Test("EventData")
    func eventServiceFiltersEventsByInterval() async throws {
        let eventStore = EKEventStore()
        let includedTimeIntervals = [300.0, 600.0]
        let excludedTimeIntervals = [900.0, 1200.0]
   
        let includedEvents = includedTimeIntervals.map { double in
            createEvent(
                store: eventStore,
                startDate: Date.now.addingTimeInterval(double),
                endDate: Date.now.addingTimeInterval(double + 10)
            )
        }
        let excludedEvents = excludedTimeIntervals.map { double in
            createEvent(
                store: eventStore,
                startDate: Date.now.addingTimeInterval(double),
                endDate: Date.now.addingTimeInterval(double + 10)
            )
        }
        
        let eventService = try createEventService(
            events: includedEvents + excludedEvents,
            authorizationStatus: .fullAccess
        )
        
        let interval = DateInterval(
            start: Date.now,
            duration: 700
        )
        
        let fetchedEvents = eventService.getEvents(
            from: eventService.eventStore,
            for: interval
        )
        
        for fetchedEvent in fetchedEvents {
            #expect(includedEvents.contains(where: { event in
                event.startDate == fetchedEvent.startDate && event.endDate == fetchedEvent.endDate
            }))
        }
        
        for fetchedEvent in fetchedEvents {
            #expect(!excludedEvents.contains(where: { event in
                event.startDate == fetchedEvent.startDate && event.endDate == fetchedEvent.endDate
            }))
        }
    }
}

