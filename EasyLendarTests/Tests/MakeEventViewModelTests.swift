import XCTest
@testable import SlonikLendar
final class MakeEventViewModelTests: XCTestCase {
    
    var mockCoreDataManager: MockCoreDataManager!
    var makeEventViewModel: MakeEventViewModel!
    
    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        makeEventViewModel = MakeEventViewModel(coreDataManager: mockCoreDataManager)
    }

    override func tearDownWithError() throws {
        mockCoreDataManager = nil
        makeEventViewModel = nil
    }
    //MARK: - Start Date Time
    func testStartDateTimeCreateCorrectTimeWith0000() throws {
        //Given
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: 2015, month: 5, day: 19)),
              let startTime = calendar.date(from: DateComponents(hour: 00, minute: 00)),
              let expectedResult = calendar.date(from: DateComponents(year: 2015, month: 5, day: 19, hour: 00, minute: 00))
        else { throw CustomErrors.wrongDate }
        //When
        let startDateTime = makeEventViewModel.startDateTime(startDate: startDate, startTime: startTime)
        //Then
        XCTAssertEqual(startDateTime, expectedResult)
    }
    func testStartDateTimeCreateCorrectTimeWith2359() throws {
        //Given
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31)),
              let startTime = calendar.date(from: DateComponents(hour: 23, minute: 59)),
              let expectedResult = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31, hour: 23, minute: 59))
        else { throw CustomErrors.wrongDate }
        //When
        let startDateTime = makeEventViewModel.startDateTime(startDate: startDate, startTime: startTime)
        //Then
        XCTAssertEqual(startDateTime, expectedResult)
    }
    //MARK: - End Date Time
    func testEndDateTimeCreateCorrectTimeWith0000() throws {
        //Given
        let calendar = Calendar.current
        guard let endDate = calendar.date(from: DateComponents(year: 2015, month: 5, day: 19)),
              let endTime = calendar.date(from: DateComponents(hour: 00, minute: 00)),
              let expectedResult = calendar.date(from: DateComponents(year: 2015, month: 5, day: 19, hour: 00, minute: 00))
        else { throw CustomErrors.wrongDate }
        //When
        let endDateTime = makeEventViewModel.endDateTime(endDate: endDate, endTime: endTime)
        //Then
        XCTAssertEqual(endDateTime, expectedResult)
    }
    func testEndDateTimeCreateCorrectTimeWith2359() throws {
        //Given
        let calendar = Calendar.current
        guard let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31)),
              let endTime = calendar.date(from: DateComponents(hour: 23, minute: 59)),
              let expectedResult = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31, hour: 23, minute: 59))
        else { throw CustomErrors.wrongDate }
        //When
        let endDateTime = makeEventViewModel.endDateTime(endDate: endDate, endTime: endTime)
        //Then
        XCTAssertEqual(endDateTime, expectedResult)
    }
    //MARK: - Core Data Methods
    func testSaveWorkCorrect () throws {
        //Given
        let event = Event(id: UUID(), name: "SlonikLendar cool 🐘", startDate: Date.now, endDate: Date.now, isAllDay: false, notifications: true)
        //When
        makeEventViewModel.save(event: event)
        //Then
        XCTAssert(mockCoreDataManager.createCalled)
        XCTAssertEqual(mockCoreDataManager.createEvent?.id, event.id )
    }
    func testUpdateWorkCorrect () throws {
        //Given
        let event = Event(id: UUID(), name: "Use SlonikLendar and you won't regret it", startDate: Date.now, endDate: Date.now, isAllDay: true, notifications: false)
        //When
        makeEventViewModel.update(event: event)
        //Then
        XCTAssert(mockCoreDataManager.updateCalled)
        XCTAssertEqual(mockCoreDataManager.updateEvent?.id, event.id )
    }
    func testDeleteWorkCorrect () throws {
        //Given
        let event = Event(id: UUID(), name: "Use SlonikLendar and you won't regret it", startDate: Date.now, endDate: Date.now, isAllDay: true, notifications: false)
        //When
        makeEventViewModel.delete(event: event)
        //Then
        XCTAssert(mockCoreDataManager.deleteCalled)
        XCTAssertEqual(mockCoreDataManager.deleteEvent?.id, event.id )
    }
}
