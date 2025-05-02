//
//  iOSTechTestUITests.swift
//  iOSTechTestUITests
//
//  Created by Stone Zhang on 2023/11/26.
//

import XCTest

final class iOSTechTestUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWelcomeViewIsVisibleOnLaunch() {
            let app = XCUIApplication()
            app.launch()
            
            XCTAssertTrue(app.staticTexts["Welcome to the"].exists)
        }

    func testSearchAndSeeResults() {
        let app = XCUIApplication()
        app.launch()
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("love")
       
        let firstCell = app.cells.firstMatch
        let exists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
