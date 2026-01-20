import XCTest
@testable import SlonikLendar

final class PageViewModelTests: XCTestCase {
    
    var pageViewModel: PageViewModelProtocol!
    var mockCalendarHelper: MockCalendarHelper!
    
    override func setUpWithError() throws {
        mockCalendarHelper = MockCalendarHelper()
        pageViewModel = PageViewModel(calendar: Calendar.current, helper: mockCalendarHelper)
    }

    override func tearDownWithError() throws {
        pageViewModel = nil
        mockCalendarHelper = nil
    }
    //MARK: - Add Button Taped
    func testAddButtonTapedCausesClosure() throws {
        //Given
        var addButtonTapedCausesClosure = false
        let expectedResult = true
        //When
        pageViewModel.onAddEventRequest = {
            addButtonTapedCausesClosure = true
        }
        pageViewModel.addButtonTaped()
        //Then
        XCTAssertEqual(addButtonTapedCausesClosure, expectedResult)
    }
    //MARK: - Mark Years
    func testMakeYearsCausesClosure() throws {
        //Given
        var makeYearsCausesClosure = false
        let expectedResult = true
        //When
        pageViewModel.onUpdate = { _ in
            makeYearsCausesClosure = true
        }
        pageViewModel.makeYears(lowerLimit: 1000, upperLimit: 2000)
        //Then
        XCTAssertEqual(makeYearsCausesClosure, expectedResult)
    }
    func testMakeYearsCausesHelperMethod() throws {
        //Given
        var makeYearsCausesHelperMethod = false
        let expectedResult = true
        //When
        pageViewModel.makeYears(lowerLimit: 1000, upperLimit: 2000)
        makeYearsCausesHelperMethod = mockCalendarHelper.makeMonthsCalled
        //Then
        XCTAssertEqual(makeYearsCausesHelperMethod, expectedResult)
    }
    func testMakeYearsCreateYearsWithCorrectBoundaries() throws {
        //Given
        let lowerLimit = 2000
        let upperLimit = 2005
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2000, month: 5, day: 3)) else { throw CustomErrors.wrongDate }
        mockCalendarHelper.makeMonths = [MonthModel(date: date, days: [])]
        var viewModelState: [YearModel] = []
        pageViewModel.onUpdate = { state in
            viewModelState = state.years
        }
        //When
        pageViewModel.makeYears(lowerLimit: lowerLimit, upperLimit: upperLimit)
        //Then
        XCTAssertEqual(viewModelState.count, upperLimit-lowerLimit+1)
        XCTAssertEqual(viewModelState[0].year, lowerLimit)
        XCTAssertEqual(viewModelState[5].year, upperLimit)
    }
}
