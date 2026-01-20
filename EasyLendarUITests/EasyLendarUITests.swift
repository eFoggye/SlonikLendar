//
//  EasyLendarUITests.swift
//  EasyLendarUITests
//
//  Created by Egor on 06.01.2026.
//

import XCTest

final class EasyLendarUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSwipesWorkCorrect() throws {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.activate()
        let cellsQuery = slonikLendarApp.cells
        cellsQuery/*@START_MENU_TOKEN@*/.containing(.staticText, identifier: "30").firstMatch/*[[".element(boundBy: 32)",".containing(.staticText, identifier: \"30\").firstMatch"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        cellsQuery.element(boundBy: 37).swipeRight()
        cellsQuery.element(boundBy: 38).swipeRight()
    }
    func testDayCellPresentTimelineWhenTap() {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.activate()
        slonikLendarApp/*@START_MENU_TOKEN@*/.staticTexts["22"]/*[[".otherElements.staticTexts[\"22\"]",".staticTexts[\"22\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
    }
    func testEventViewIsUserInteraction () throws {
        let slonikLendarApp = XCUIApplication(bundleIdentifier: "f0ggy.SlonikLendar")
        slonikLendarApp.activate()
        slonikLendarApp/*@START_MENU_TOKEN@*/.staticTexts["22"]/*[[".otherElements.staticTexts[\"22\"]",".staticTexts[\"22\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        slonikLendarApp.scrollViews/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.other, identifier: \"Horizontal scroll bar, 1 page\").firstMatch",".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
