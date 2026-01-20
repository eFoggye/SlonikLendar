import Foundation
@testable import SlonikLendar

class MockCoreDataManager: CoreDataManagerProtocol {
    private(set) var createCalled = false
    private(set) var updateCalled = false
    private(set) var deleteCalled = false
    private(set) var fetchForDateCalled = false
    private(set) var fetchAllCalled = false
    
    private(set) var createEvent: Event?
    private(set) var updateEvent: Event?
    private(set) var deleteEvent: Event?
    
    var fetchForDateStubbedEvents: [Event] = []
    var fetchAllStubbedEvents: [Event] = []
    
    func create(event: Event) {
        createCalled = true
        createEvent = event
    }
    
    func fetchEvents() -> [Event] {
        fetchAllCalled = true
        return fetchAllStubbedEvents
    }
    
    func fetchEvent(for date: Date) -> [Event] {
        fetchForDateCalled = true
        return fetchForDateStubbedEvents
    }
    
    func update(event: Event) {
        updateCalled = true
        updateEvent = event
    }
    
    func delete(event: Event) {
        deleteCalled = true
        deleteEvent = event
    }
    
    
}
