//
//  CalendarHelperTests.swift
//  SLonikLendarTests
//
//  Created by Egor on 19.01.2026.
//

import XCTest
@testable import SlonikLendar
final class CalendarHelperTests: XCTestCase {
    
    var helper: CalendarHelper!
    
    override func setUpWithError() throws {
        helper = CalendarHelper()
    }
    
    override func tearDownWithError() throws {
        helper = nil
    }
    //MARK: - Number Of Day
    func testNumberOfDaysJanuary() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = 31
        //When
        let numberOfdDays = helper.numberOfDay(in: month)
        //Then
        XCTAssertEqual(numberOfdDays, expectedResult)
    }
    func testNumberOfDaysFebruaryLeapYear() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2028, month: 2, day: 1)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = 29
        //When
        let numberOfDays = helper.numberOfDay(in: month)
        //Then
        XCTAssertEqual(numberOfDays, expectedResult)
    }
    func testNumberOfDaysFebruaryNonLeapYear() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2026, month: 2, day: 1)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = 28
        //When
        let numberOfDays = helper.numberOfDay(in: month)
        //Then
        XCTAssertEqual(numberOfDays, expectedResult)
    }
    //MARK: - Russian Name Of Month
    func testRussianNameOfDecember() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2026, month: 12, day: 1)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = "Декабрь"
        //When
        let russianNameOfMonth = helper.russianNameOfMonth(month: month)
        //Then
        XCTAssertEqual(russianNameOfMonth, expectedResult)
    }
    //MARK: - Start Day
    func testStartDayJanuary() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2026, month: 1, day: 23)) else { throw CustomErrors.wrongDate }
        let expectedResult = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))
        //When
        let startDay = helper.startOfMonth(for: date)
        //Then
        XCTAssertEqual(startDay, expectedResult)
    }
    //MARK: - Make Months
    func testMakeMonthsCreate12Months() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2034, month: 7, day: 17)) else { throw CustomErrors.wrongDate }
        let expectedResult = 12
        //When
        let months = helper.makeMonths(for: date)
        //Then
        XCTAssertEqual(months.count, expectedResult)
    }
    func testMakeMonthsEveryMonthYearEqualToInputDayYear () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2010, month: 3, day: 22)) else { throw CustomErrors.wrongDate }
        let expectedResult = 2010
        //When
        let months = helper.makeMonths(for: date)
        //Then
        months.forEach({
            let year = calendar.component(.year, from: $0.date)
            XCTAssertEqual(year, expectedResult)
        })
    }
    func testMakeMonthsAllMonthsInTheRightOrder() throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 1994, month: 10, day: 13)) else { throw CustomErrors.wrongDate }
        //When
        let months = helper.makeMonths(for: date)
        //Then
        let firstMonth = calendar.component(.month, from: months[0].date)
        let lastMonth = calendar.component(.month, from: months[11].date)
        XCTAssertEqual(firstMonth, 1)
        XCTAssertEqual(lastMonth, 12)
    }
    func testMakeMonthEveryMonthDaysNotIsEmpty () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2020, month: 8, day: 3)) else { throw CustomErrors.wrongDate }
        let expectedResult = false
        //When
        let months = helper.makeMonths(for: date)
        //Then
        months.forEach({
            XCTAssertEqual($0.days.isEmpty, expectedResult)
        })
    }
    //MARK: - Make Days
    func testMakeDaysAllDaysMonthEqualToInputMonth () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2007, month: 9, day: 21)) else { throw CustomErrors.wrongDate }
        let expectedResult = calendar.component(.month, from: date)
        let month = MonthModel(date: date, days: [])
        //When
        let days = helper.makeDays(for: month)
        //Then
        days.forEach({
            if $0.isItInThismonth {
                let dayMonth = calendar.component(.month, from: $0.date)
                XCTAssertEqual(dayMonth, expectedResult)
            }
        })
    }
    func testMakeDaysCreate42Days () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2033, month: 11, day: 2)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = 42
        //When
        let days = helper.makeDays(for: month)
        //Then
        XCTAssertEqual(days.count, expectedResult)
    }
    func testMakeDaysForJanuaryCreate31Days () throws {
        //Given
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2022, month: 1, day: 7)) else { throw CustomErrors.wrongDate }
        let month = MonthModel(date: date, days: [])
        let expectedResult = 31
        //When
        let days = helper.makeDays(for: month)
        var tempResult = 0
        //Then
        days.forEach({
            if $0.isItInThismonth { tempResult += 1 }
        })
        XCTAssertEqual(tempResult, expectedResult)
    }
}
