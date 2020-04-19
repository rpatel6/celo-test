//
//  DateTest.swift
//  Celo testTests
//
//  Created by Raj Patel on 19/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import XCTest
@testable import Celo_test
class DateTest: XCTestCase {

    func testPrettyDate1() {
        let dateString = "2013-03-31T09:43:14.348Z"
        let prettyString = Date.convertToPrettyString(from: dateString)
        XCTAssertTrue(prettyString == "31/03/2013", "Date string should be 31/03/2013 not \(prettyString ?? "nil")")
    }
    
    func testPrettyDate2() {
        let dateString = "2002-05-30T23:54:20.946Z"
        let prettyString = Date.convertToPrettyString(from: dateString)
        XCTAssertTrue(prettyString == "31/05/2002", "Date string should be 31/05/2002 not \(prettyString ?? "nil")")
    }
    
    func testPrettyDate3() {
        let dateString = "1951-02-08T23:48:30.316Z"
        let prettyString = Date.convertToPrettyString(from: dateString)
        XCTAssertTrue(prettyString == "09/02/1951", "Date string should be 09/02/1951 not \(prettyString ?? "nil")")
    }
    
    func testPrettyDateUnexpectedFormat() {
        let dateString = "2013-03-31T09:43:14Z"
        let prettyString = Date.convertToPrettyString(from: dateString)
        XCTAssertTrue(prettyString == nil, "Date string should be nil not \(prettyString ?? "nil")")
    }
}
