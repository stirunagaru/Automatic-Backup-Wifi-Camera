//
//  CameraTest.swift
//  Automatic Backup WiFi CameraTests
//
//  Created by Shivang Dave on 7/26/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import XCTest
@testable import Automatic_Backup_WiFi_Camera

class CameraTest: XCTestCase
{
    let vc = UIViewController()
    let testToken = testAlamo()

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testConnect()
    {
        let x = testToken.testIt()
        XCTAssert(x == true)
    }

    func testPerformanceExample()
    {
        self.measure
        {
            
        }
    }

}
