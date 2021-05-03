//
//  lifelogTests.swift
//  lifelogTests
//
//  Created by Shigeru Hagiwara on 2020/09/04.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import XCTest
@testable import lifelog

class lifelogTests: XCTestCase {

    let healthDataService = HealthDataService.instance
    
    override func setUp() {
        let statusWatcher = DummyWatcher()
        healthDataService.watcher = statusWatcher
        healthDataService.prepareDocumentContainer()
    }

    override func tearDown() {
    }

    func testExample() {
        // TODO: do something
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
