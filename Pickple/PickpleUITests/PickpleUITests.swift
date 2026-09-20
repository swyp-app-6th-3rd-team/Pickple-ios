//
//  PickpleUITests.swift
//  PickpleUITests
//
//  Created by 박윤수 on 8/24/26.
//

import XCTest

final class PickpleUITests: XCTestCase {

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
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    @MainActor
    func testSortDropdownToggle() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(1)

        let guestButton = app.staticTexts["게스트로 둘러보기"]
        if guestButton.waitForExistence(timeout: 3) {
            guestButton.tap()
            sleep(1)
        }

        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)

        let sortButton = app.staticTexts["최신순"].firstMatch
        XCTAssertTrue(sortButton.waitForExistence(timeout: 5), "정렬 버튼을 못 찾음")

        func saveShot(_ name: String) {
            let shot = app.screenshot()
            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
            try? shot.pngRepresentation.write(to: url)
        }

        saveShot("shot0_before.png")
        sortButton.tap()
        sleep(1)
        saveShot("shot1_afterFirstTap.png")
        sortButton.tap()
        sleep(1)
        saveShot("shot2_afterSecondTap.png")

        let dump = "buttons matching 최신순: \(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "최신순")).count), staticTexts matching 최신순: \(app.staticTexts.matching(NSPredicate(format: "label == %@", "최신순")).count)"
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("pickple_dropdown_result.txt")
        try? dump.write(to: url, atomically: true, encoding: .utf8)
        print("=== DROPDOWN TEST === \(dump)")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
