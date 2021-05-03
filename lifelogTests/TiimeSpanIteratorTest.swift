//
//  TiimeSpanIteratorTest.swift
//  lifelogTests
//
//  Created by Shigeru Hagiwara on 2020/09/11.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import XCTest
@testable import lifelog

class TiimeSpanIteratorTest: XCTestCase {
    func testExample() {
        let calendar = NSCalendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -2, to: now)!
        let endDate = now
        
        let iterator = TimeSpanIterator(calendar, from: startDate, to: endDate,
                                        byStepping: .hour, value: 1)
        iterator.iterate { (startDate, endDate) in
            print("\(startDate) : \(endDate)")
        }
    }
}
