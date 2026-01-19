import Foundation
@testable import SlonikLendar

class MockCoreDataManager: CoreDataManagerProtocol {
    private(set) var createCalled = false
    private(set) var updateCalled = false
    private(set) var deleteCalled = false
    private(set) var fetchCalled = false
    
    private(set) var createEvent: Event?
    private(set) var updateEvent: Event?
    private(set) var deleteEvent: Event?
    
    var fetchStubbedEvents: [Event] = []
    
    func create(event: Event) {
        createCalled = true
        createEvent = event
    }
    
    func fetchEvents() -> [Event] {
        return []
    }
    
    func fetchEvent(for date: Date) -> [Event] {
        fetchCalled = true
        return fetchStubbedEvents
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
