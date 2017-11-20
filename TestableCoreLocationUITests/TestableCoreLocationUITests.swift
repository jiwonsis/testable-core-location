//
//  TestableCoreLocationUITests.swift
//  TestableCoreLocationUITests
//
//  Created by Scott moon on 31/10/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest

class TestableCoreLocationUITests: XCTestCase {
     var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launchArguments = ["UITests"]
        app.launch()
    }
    
    func test_maximumSpeed_setMaximumSpeed() {
        
        let locationAlert = app.alerts["위치 서비스 앱 접근 권한"]
        waitForExistence(of: locationAlert)
        locationAlert.buttons["허용"].tap()
        
        let blueLabel = app.otherElements["SpeedLabelBlue"]
        XCTAssertEqual("0", blueLabel.label)
        
        app.buttons["Max Speed"].tap()
        
        let maxSpeedAlert = app.alerts["최대 속도 선택"]
        waitForExistence(of: maxSpeedAlert)
        
        let textField = maxSpeedAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        textField.tap()
        textField.typeText("40")
        maxSpeedAlert.buttons["OK"].tap()
        
        let whiteLabel = app.otherElements["SpeedLabelWhite"]
        XCTAssertEqual("72", whiteLabel.label)
        
        let backgroundView = app.otherElements["RootView"]
        let speedView = app.otherElements["SpeedView"]
        
        XCTAssertEqual(backgroundView.frame.height, speedView.frame.height * 2)
    }
    
    func test_authorization_denied_presentInstructionsToUser() {
        let locationAlert = app.alerts["위치 서비스 앱 접근 권한"]
        waitForExistence(of: locationAlert)
         locationAlert.buttons["허용안함"].tap()
        
        let deniedAlert = app.alerts["권한 사용안함"]
        waitForExistence(of: deniedAlert)
        deniedAlert.buttons["OK"].tap()
    }
    
}

extension XCTestCase {
    
    func waitForExistence(of element: XCUIElement, file: String = #file, line: UInt = #line) {
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 3) { (error) in
            guard error != nil else { return }
            
            let description = "\(element) does not exist after 3 seconds."
            self.recordFailure(withDescription: description, inFile: file, atLine: Int(line), expected: true)
        }
    }
}

