import XCTest
@testable import SlonikLendar
final class CoreDataTests: XCTestCase {

    var coreDataManager: CoreDataManagerProtocol!
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManager(container: CoreDataInMemoryPersistantContainer.makeContainer())
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
    }
    //MARK: - Fetch Events
    func testFetchEventsWorkCorrectWith1Event() throws {
        //Given
        let event1 = Event(id: UUID(), name: "Slonik", startDate: Date.now, endDate: Date.now, isAllDay: false, notifications: false)
        //When
        coreDataManager.create(event: event1)
        
        let events = coreDataManager.fetchEvents()
        //Then
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0].id, event1.id)
    }
    func testFetchEventsWorkCorrectWith0Event() throws {
        //Given
        let events = coreDataManager.fetchEvents()
        //When
        
        //Then
        XCTAssertEqual(events.count, 0)
    }
    //MARK: - Fetch For Date
    func testFetchForDateWorkСorrectlyWith2EventsWithDifferentDates() throws {
        //Given
        let calendar = Calendar.current
        guard
                let startDate1 = calendar.date(from: DateComponents(year: 2029, month: 7, day: 2, hour: 15, minute: 25)),
                let endDate1 = calendar.date(from: DateComponents(year: 2029, month: 7, day: 2, hour: 17, minute: 05)),
        
                let startDate2 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 02, minute: 40)),
                let endDate2 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 12, minute: 30)),
                let fetchDate = calendar.date(from: DateComponents(year: 2029, month: 7, day: 2))
        else { throw CustomErrors.wrongDate }
        
        let event1 = Event(id: UUID(), name: "Egor", startDate: startDate1, endDate: endDate1, isAllDay: false, notifications: false)
        let event2 = Event(id: UUID(), name: "Lukichev", startDate: startDate2, endDate: endDate2, isAllDay: false, notifications: false)
        //When
        coreDataManager.create(event: event1)
        coreDataManager.create(event: event2)
        let result = coreDataManager.fetchEvent(for: fetchDate)
        //Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, event1.id)
    }
    func testFetchForDateWorkСorrectlyWith2EventsWithIdenticalDates() throws {
        //Given
        let calendar = Calendar.current
        guard
                let startDate1 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 10, minute: 40)),
                let endDate1 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 11, minute: 25)),
        
                let startDate2 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 02, minute: 40)),
                let endDate2 = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14, hour: 07, minute: 30)),
                let fetchDate = calendar.date(from: DateComponents(year: 2005, month: 3, day: 14))
        else { throw CustomErrors.wrongDate }
        
        let event1 = Event(id: UUID(), name: "Egor", startDate: startDate1, endDate: endDate1, isAllDay: false, notifications: false)
        let event2 = Event(id: UUID(), name: "Lukichev", startDate: startDate2, endDate: endDate2, isAllDay: false, notifications: false)
        //When
        coreDataManager.create(event: event1)
        coreDataManager.create(event: event2)
        let result = coreDataManager.fetchEvent(for: fetchDate)
        //Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[1].id, event1.id)
        XCTAssertEqual(result[0].id, event2.id)
    }
    //MARK: - Update
    func testUpdateCorrectUpdateEvent () throws {
        //Given
        let id = UUID()
        let calendar = Calendar.current
        guard
                let startDate1 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 9, minute: 30)),
                let endDate1 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 11, minute: 00)),
        
                let startDate2 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 9, minute: 45)),
                let endDate2 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 11, minute: 30))
        else { throw CustomErrors.wrongDate }
        let oldEvent = Event(id: id, name: "Privet", startDate: startDate1, endDate: endDate1, isAllDay: false, notifications: true)
        let newEvent = Event(id: id, name: "Poka", startDate: startDate2, endDate: endDate2, isAllDay: false, notifications: false)
        //When
        coreDataManager.create(event: oldEvent)
        coreDataManager.update(event: newEvent)
        let events = coreDataManager.fetchEvents()
        //Then
        XCTAssertEqual(events[0].id, oldEvent.id)
        XCTAssertEqual(events[0].name, newEvent.name)
        XCTAssertEqual(events[0].notifications, newEvent.notifications)
    }
    //MARK: - Delete
    func testDeleteCorrectDeleteEvent () throws {
        //Given
        let id = UUID()
        let calendar = Calendar.current
        guard
                let startDate1 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 9, minute: 30)),
                let endDate1 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 20, hour: 11, minute: 00))
        else { throw CustomErrors.wrongDate }
        let event = Event(id: id, name: "Privet", startDate: startDate1, endDate: endDate1, isAllDay: false, notifications: true)
        let expectedResult = true
        //When
        coreDataManager.create(event: event)
        coreDataManager.delete(event: event)
        let events = coreDataManager.fetchEvents()
        //Then
        XCTAssertEqual(events.count == 0, expectedResult)
    }
}
