//
//  NYC_HS_SATTests.swift
//  NYC HS SATTests
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import XCTest
@testable import NYC_HS_SAT

class NYC_HS_SATTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testCallToNYCOpenDataSATScore() { // SAT API
        let token = "9ubKuJcvrZbHBNOSLWvi1a7Ux"
        let url = URL(string: "https://data.cityofnewyork.us/resource/734v-jeq5.json?&$$app_token=\(token)")
        let promise = expectation(description: "Status code: 200")
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out")
        }
    }
    
    func testCallToNYCOpenDataAllHighSchools() { // Highschool API
        let token = "9ubKuJcvrZbHBNOSLWvi1a7Ux"
        let url = URL(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json?&$$app_token=\(token)")
        let promise = expectation(description: "Status code: 200")
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test timed out")
        }
    }
}
