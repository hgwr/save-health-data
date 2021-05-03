//
//  HealthDataServiceTest.swift
//  lifelogTests
//
//  Created by Shigeru Hagiwara on 2020/09/16.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import XCTest
@testable import lifelog

class HealthDataServiceTest: XCTestCase {

    let healthDataService = HealthDataService.instance
    
    override func setUp() {
        let statusWatcher = DummyWatcher()
        healthDataService.watcher = statusWatcher
        healthDataService.prepareDocumentContainer()
    }

    override func tearDown() {
    }

    func testGetHealthData() {
        healthDataService.getHealthData(from: CalendarUtil.yesterday(), to: CalendarUtil.now())
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
