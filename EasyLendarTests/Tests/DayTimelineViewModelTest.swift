import XCTest
@testable import SlonikLendar
final class DayTimelineViewModelTests: XCTestCase {

    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDownWithError() throws {
        mockCoreDataManager = nil
    }
    //MARK: - Make Title
    func testMakeTitle() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 1997, month: 4, day: 25)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 25, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day, coreDataManager: mockCoreDataManager)
        let expectedResult = "25 апреля 1997 г."
        //When
        let title = viewModel.makeTitle()
        //Then
        XCTAssertEqual(title, expectedResult)
    }
    //MARK: - Y Position
    func testYPositionCorrectWithStartOfDayDate () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2003, month: 8, day: 19, hour: 00, minute: 00)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 19, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let expectedResult = CGFloat(60)
        //When
        let position = viewModel.yPosition(date: date)
        //Then
        XCTAssertEqual(position, expectedResult)
    }
    func testYPositionCorrectWithRandomDate () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2009, month: 3, day: 14, hour: 17, minute: 35)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 19, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let expectedResult = CGFloat(1115)
        //When
        let position = viewModel.yPosition(date: date)
        //Then
        XCTAssertEqual(position, expectedResult)
    }
    func testYPositionCorrectWithEndOfDayDate () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 23, minute: 55)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 19, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let expectedResult = CGFloat(1495)
        //When
        let position = viewModel.yPosition(date: date)
        //Then
        XCTAssertEqual(position, expectedResult)
    }
    //MARK: - Height
    func testHeightCorrectWith2355DurationEvent () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2014, month: 7, day: 18, hour: 00, minute: 00)) else { throw CustomErrors.wrongDate }
        guard let endDate = calendar.date(from: DateComponents(year: 2014, month: 7, day: 18, hour: 23, minute: 55)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 18, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let event = Event(id: UUID(), name: "Install SlonikLendar bro", startDate: date, endDate: endDate, isAllDay: false, notifications: false)
        let expectedResult = CGFloat(1435)
        //When
        let height = viewModel.height(event: event)
        //Then
        XCTAssertEqual(height, expectedResult)
    }
    func testHeightCorrectWith0005DurationEvent () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2008, month: 2, day: 24, hour: 00, minute: 00)) else { throw CustomErrors.wrongDate }
        guard let endDate = calendar.date(from: DateComponents(year: 2008, month: 2, day: 24, hour: 00, minute: 05)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 18, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let event = Event(id: UUID(), name: "You're need it", startDate: date, endDate: endDate, isAllDay: false, notifications: false)
        let expectedResult = CGFloat(5)
        //When
        let height = viewModel.height(event: event)
        //Then
        XCTAssertEqual(height, expectedResult)
    }
    func testHeightCorrectWith1120DurationEvent () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2043, month: 9, day: 11, hour: 11, minute: 50)) else { throw CustomErrors.wrongDate }
        guard let endDate = calendar.date(from: DateComponents(year: 2043, month: 9, day: 11, hour: 23, minute: 10)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 18, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day)
        let event = Event(id: UUID(), name: "I'm sure", startDate: date, endDate: endDate, isAllDay: false, notifications: false)
        let expectedResult = CGFloat(680)
        //When
        let height = viewModel.height(event: event)
        //Then
        XCTAssertEqual(height, expectedResult)
    }
    //MARK: - Load
    func testLoadCorrectWorkWith2Events() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2000, month: 10, day: 5, hour: 03, minute: 15)) else { throw CustomErrors.wrongDate }
        guard let endDate = calendar.date(from: DateComponents(year: 2000, month: 10, day: 5, hour: 07, minute: 20)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 18, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day, coreDataManager: mockCoreDataManager)
        let event1 = Event(id: UUID(), name: "I'm tired if advertising", startDate: date, endDate: endDate, isAllDay: false, notifications: false)
        let event2 = Event(id: UUID(), name: "Just load it", startDate: date, endDate: endDate, isAllDay: false, notifications: false)
        mockCoreDataManager.fetchForDateStubbedEvents = [event1, event2]
        let expectableResult = 2
        //When
        var onUpdateCalled = false
        viewModel.onUpdate = {
            onUpdateCalled = true
        }
        viewModel.load()
        //Then
        XCTAssertTrue(mockCoreDataManager.fetchForDateCalled)
        XCTAssertEqual(viewModel.events.count, expectableResult)
        XCTAssertEqual(viewModel.events[0].id, event1.id)
        XCTAssertEqual(viewModel.events[1].id, event2.id)
        XCTAssert(onUpdateCalled)
    }
    func testLoadCorrectWorkWith0Events() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2099, month: 1, day: 1, hour: 01, minute: 15)) else { throw CustomErrors.wrongDate }
        let day = DayModel(date: date, day: 18, isToday: false, isCurrentMonth: false, isItInThismonth: true)
        let viewModel = DayTimelineViewModel(day: day, coreDataManager: mockCoreDataManager)
        let expectedResult = 0
        //When
        var onUpdateCalled = false
        viewModel.onUpdate = {
            onUpdateCalled = true
        }
        viewModel.load()
        //Then
        XCTAssertTrue(mockCoreDataManager.fetchForDateCalled)
        XCTAssertEqual(viewModel.events.count, expectedResult)
        XCTAssert(onUpdateCalled)
    }
}
