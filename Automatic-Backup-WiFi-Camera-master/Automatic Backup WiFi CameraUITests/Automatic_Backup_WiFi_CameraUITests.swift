//
//  Automatic_Backup_WiFi_CameraUITests.swift
//  Automatic Backup WiFi CameraUITests
//
//  Created by Shivang Dave on 7/16/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import XCTest
@testable import Automatic_Backup_WiFi_Camera

class Automatic_Backup_WiFi_CameraUITests: XCTestCase
{
    var app: XCUIApplication!
    
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
//        app.launchEnvironment = ["UITEST_DISABLE_ANIMATIONS" : "YES"]
        app.launch()
    }
    
    override func tearDown()
    {
        super.tearDown()
        app = nil
    }
    
    func testNavigation()
    {
        let sp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = sp.buttons["Allow"]
        if allow.exists
        {
            allow.tap()
        }
        app.buttons["btn"].tap()
        XCTAssert(app.navigationBars["CONNECT TO WiFi"].exists)
        
        app.buttons["btn1"].tap()
        XCTAssert(app.navigationBars["CAMERA TEST"].exists)
        
        app.buttons["btn2"].tap()
        XCTAssertTrue(app.navigationBars["HOME"].exists)
    }
}
