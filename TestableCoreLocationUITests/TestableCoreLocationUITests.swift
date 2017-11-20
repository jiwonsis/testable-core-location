//
//  TestableCoreLocationUITests.swift
//  TestableCoreLocationUITests
//
//  Created by Scott moon on 31/10/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import XCTest

class TestableCoreLocationUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments = ["UITests"]
        app.launch()
    }
    
}
