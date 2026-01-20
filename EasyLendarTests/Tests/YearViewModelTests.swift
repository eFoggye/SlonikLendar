import XCTest
@testable import SlonikLendar

final class YearViewModelTests: XCTestCase {
    
    var yearViewModel: YearViewModelProtocol!
    var mockCoreDataManager: MockCoreDataManager!
    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        yearViewModel = YearViewModel(coreDataManager: mockCoreDataManager)
    }

    override func tearDownWithError() throws {
        mockCoreDataManager = nil
        yearViewModel = nil
    }
    //MARK: - Has Events
    func testHasEventsCausesClosure() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2002, month: 11, day: 3)) else { throw CustomErrors.wrongDate }
        let expectedResult = true
        var hasEventsCausesClosure = false
        //When
        yearViewModel.hasEvents(for: date)
        hasEventsCausesClosure = mockCoreDataManager.fetchForDateCalled
        //Then
        XCTAssertEqual(hasEventsCausesClosure, expectedResult)
    }
    func testHasEventsWith0FetchEvents() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2002, month: 11, day: 3)) else { throw CustomErrors.wrongDate }
        mockCoreDataManager.fetchForDateStubbedEvents = []
        let expectedResult = false
        //When
        let result = yearViewModel.hasEvents(for: date)
        //Then
        XCTAssertEqual(result, expectedResult)
    }
    func testHasEventsWith1FetchEvents() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2002, month: 11, day: 3)) else { throw CustomErrors.wrongDate }
        let event = Event(id: UUID(), name: "Probably last test...", startDate: Date.now, endDate: Date.now, isAllDay: false, notifications: false)
        mockCoreDataManager.fetchForDateStubbedEvents = [event]
        let expectedResult = true
        //When
        let result = yearViewModel.hasEvents(for: date)
        //Then
        XCTAssertEqual(result, expectedResult)
    }
}
