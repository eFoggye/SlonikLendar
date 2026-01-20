import Foundation
@testable import SlonikLendar
class MockCalendarHelper: CalendarHelperProtocol {
    private(set) var russianNameOfMonthCalled = false
    private(set) var startOfMonthCalled = false
    private(set) var numberOfDayCalled = false
    private(set) var makeDaysCalled = false
    private(set) var makeMonthsCalled = false
    
    var russianNameOfMonth: String = ""
    var startOfMonth: Date = Date.now
    var numberOfDay: Int = 0
    var makeDays: [DayModel] = []
    var makeMonths: [MonthModel] = []
    
    func russianNameOfMonth(month: MonthModel) -> String {
        russianNameOfMonthCalled = true
        return russianNameOfMonth
    }
    
    func startOfMonth(for date: Date) -> Date {
        startOfMonthCalled = true
        return startOfMonth
    }
    
    func numberOfDay(in month: MonthModel) -> Int {
        numberOfDayCalled = true
        return numberOfDay
    }
    
    func makeDays(for month: MonthModel) -> [DayModel] {
        makeDaysCalled = true
        return makeDays
    }
    
    func makeMonths(for date: Date) -> [MonthModel] {
        makeMonthsCalled = true
        return makeMonths
    }
    
    
}
