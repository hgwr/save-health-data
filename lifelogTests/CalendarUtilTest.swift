//
//  CalendarUtilTest.swift
//  lifelogTests
//
//  Created by Shigeru Hagiwara on 2020/10/14.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import XCTest
@testable import lifelog

class CalendarUtilTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTheDate() {
        let theDate = CalendarUtil.theDate(2020, 10, 14)
        let components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: theDate)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(14, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        XCTAssertEqual(0, components.nanosecond)
    }
    
    func testEndOfMonth() {
        let endOfMonth = CalendarUtil.endOfTheMonth(2020, 10)
        let components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
    }
    
    func testLastFourMonth() {
        let theDate = CalendarUtil.beginningOfToday(referenceDate: CalendarUtil.theDate(2020, 10, 14))
        let firstMonthBeginning = CalendarUtil.beginningOfTheMonth(referenceDate: theDate)
        var components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: firstMonthBeginning)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        
        let firstMonthEnd = CalendarUtil.endOfTheMonth(referenceDate: firstMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: firstMonthEnd)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
        
        let secondMonthBeginning = CalendarUtil.lastMonth(referenceDate: firstMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: secondMonthBeginning)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        
        let secondMonthEnd = CalendarUtil.endOfTheMonth(referenceDate: secondMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: secondMonthEnd)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(30, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
        
        let thirdMonthBeginning = CalendarUtil.lastMonth(referenceDate: secondMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: thirdMonthBeginning)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(8, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)

        let thirdMonthEnd = CalendarUtil.endOfTheMonth(referenceDate: thirdMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: thirdMonthEnd)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(8, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)

        let fourthMonthBeginning = CalendarUtil.lastMonth(referenceDate: thirdMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: fourthMonthBeginning)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(7, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)

        let fourthMonthEnd = CalendarUtil.endOfTheMonth(referenceDate: fourthMonthBeginning)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: fourthMonthEnd)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(7, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
    }

    func testSpecificMonthSpan() {
        var theDate = CalendarUtil.beginningOfToday(referenceDate: CalendarUtil.theDate(2020, 10, 14))
        
        var (beginningOfMonth, endOfMonth) = CalendarUtil.specificMonthSpan(relativeMonth: .thisMonth, referenceDate: theDate)
        var components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: beginningOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(10, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
        
        theDate = CalendarUtil.beginningOfToday(referenceDate: CalendarUtil.theDate(2020, 9, 14))
        (beginningOfMonth, endOfMonth) = CalendarUtil.specificMonthSpan(relativeMonth: .thisMonth, referenceDate: theDate)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: beginningOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(30, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
        
        theDate = CalendarUtil.beginningOfToday(referenceDate: CalendarUtil.theDate(2020, 10, 14))
        (beginningOfMonth, endOfMonth) = CalendarUtil.specificMonthSpan(relativeMonth: .lastMonth, referenceDate: theDate)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: beginningOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(9, components.month)
        XCTAssertEqual(30, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
        
        (beginningOfMonth, endOfMonth) = CalendarUtil.specificMonthSpan(relativeMonth: .secondMonthAgo, referenceDate: theDate)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: beginningOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(8, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(8, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)

        (beginningOfMonth, endOfMonth) = CalendarUtil.specificMonthSpan(relativeMonth: .thirdMonthAgo, referenceDate: theDate)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: beginningOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(7, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(0, components.second)
        components = CalendarUtil.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: endOfMonth)
        XCTAssertEqual(2020, components.year)
        XCTAssertEqual(7, components.month)
        XCTAssertEqual(31, components.day)
        XCTAssertEqual(23, components.hour)
        XCTAssertEqual(59, components.minute)
        XCTAssertEqual(59, components.second)
    }
}
