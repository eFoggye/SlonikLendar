//
//  EasyLendarUITests.swift
//  EasyLendarUITests
//
//  Created by Egor on 06.01.2026.
//

import XCTest

final class EasyLendarUITests: XCTestCase {
    
    @MainActor
    func testSwipesWorkCorrect() throws {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.launch()
        
        let currentExcpectedResult = "2026"
        let currentYear = slonikLendarApp.descendants(matching: .any)["\(currentExcpectedResult)"]
        
        XCTAssertTrue(currentYear.waitForExistence(timeout: 2))
        
        slonikLendarApp.swipeLeft()
        
        let nextExcpectedResult = "2027"
        let nextYear = slonikLendarApp.descendants(matching: .any)["\(nextExcpectedResult)"]
        
        XCTAssertTrue(nextYear.waitForExistence(timeout: 2))
    }
    
    func testDayCellPresentTimelineWhenTap() {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.launch()
        
        let cell = slonikLendarApp.collectionViews.cells.staticTexts["10"]
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        cell.tap()
        
        let line = slonikLendarApp.otherElements["line"]
        XCTAssertTrue(line.waitForExistence(timeout: 2))
    }
    func testAddEventButtonIsUserInteractionAndPresentCorrectScreen () throws {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.launch()
        
        let button = slonikLendarApp.buttons["addEventButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2))
        button.tap()
        
        let textField = slonikLendarApp.textFields["nameTextField"]
        XCTAssertTrue(textField.waitForExistence(timeout: 2))
    }
    func testEventAddedAndUserInteractible() throws {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.launch()
        
        let button = slonikLendarApp.buttons["addEventButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2))
        button.tap()
        
        let textField = slonikLendarApp.textFields["nameTextField"]
        XCTAssertTrue(textField.waitForExistence(timeout: 2))
        textField.tap()
        textField.typeText("Test event")
        
        let saveButton = slonikLendarApp.buttons["saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
        
        let dateNow = Calendar.current.component(.day, from: Date.now)
        let dayCell = slonikLendarApp.collectionViews.cells.staticTexts["\(dateNow)"]
        XCTAssertTrue(dayCell.waitForExistence(timeout: 2))
        dayCell.tap()
        
        let eventView = slonikLendarApp.otherElements["Test event"]
        XCTAssertTrue(eventView.waitForExistence(timeout: 2))
        eventView.tap()
        
        let eventTextField = slonikLendarApp.textFields["nameTextField"]
        XCTAssertTrue(eventTextField.waitForExistence(timeout: 2))
        let textInTextField = eventTextField.value as? String
        XCTAssertEqual(textInTextField, "Test event")
        
        let deleteButton = slonikLendarApp.buttons["deleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()
    }
}
