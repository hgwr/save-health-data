//
//  UserHealthDatabase.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/23.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation
import UIKit

public class UserHealthDatabase {
    public struct UserHealthDatabaseError: Error {}
    public struct UserHealthDatabaseErrorIO: Error {}
    
    public let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    var transactions: Dictionary<String, Bool> = [:]
    var isDataStoringFinished = false
    var gotIOError = false
    var dataSetCount = 0
    var lastDataUpdatedAt = Date()
    
    var completionHandler: ((Error?) -> Void)?
    var progressHandler: ((Int) -> Void)?
    var timeoutHandler: ((Error?) -> Void)?
    
    let checkIntervalSeconds: Double = 1
    let timeoutSeconds: Int = 60 * 15
    let thresholdSeconds: Int = 10
    
    let documentURL: URL!
    let csvStore: CSVStoreService!

    init(saveTo: URL) {
        self.documentURL = saveTo
        self.csvStore = CSVStoreService(to: self.documentURL, deviceId)
    }
    
    //MARK:- Watcher
    
    public func startWatcher() {
        print(#file, #line, "\(Date()): start UserHealthDatabase.startWatcher...")
        DispatchQueue.global(qos: .utility).async {
            let timeLimit = CalendarUtil.calendar.date(byAdding: .second, value: self.timeoutSeconds, to: Date())!
            while true {
                print(#file, #line, "\(Date()): in UserHealthDatabase.startWatcher loop...")
                Thread.sleep(forTimeInterval: self.checkIntervalSeconds)
                if let handler = self.progressHandler {
                    handler(self.dataSetCount)
                }
                if self.gotIOError {
                    if let handler = self.completionHandler {
                        self.isDataStoringFinished = false
                        handler(UserHealthDatabaseErrorIO())
                        break
                    }
                }
                let now = Date()
                self.synchronized(self) {
                    let lastUpdatedAtPlusThreshold = CalendarUtil.calendar.date(byAdding: .second, value: self.thresholdSeconds, to: self.lastDataUpdatedAt)!
                    if lastUpdatedAtPlusThreshold < now && self.transactions.count == 0 {
                        print(#file, #line, "\(Date()): self.isDataStoringFinished = true")
                        self.isDataStoringFinished = true
                    }
                }
                if self.isDataStoringFinished {
                    if let handler = self.progressHandler {
                        handler(self.dataSetCount)
                    }
                    if let handler = self.completionHandler {
                        handler(nil)
                        self.isDataStoringFinished = false
                        break
                    }
                }
                if timeLimit < now {
                    if let handler = self.timeoutHandler {
                        self.isDataStoringFinished = false
                        handler(UserHealthDatabaseError())
                        break
                    }
                }
            }
            self.dataSetCount = 0
            print(#file, #line, "\(Date()): exit UserHealthDatabase.startWatcher thread")
        }
    }
    
    //MARK:- Methods to set data

    public func setValue(from startDate: Date, to endDate: Date, key: String, value: String) {
        synchronizedTransaction {
            try csvStore.outputData(from: startDate, to: endDate, key: key, value: value)
            self.dataSetCount += 1
        }
    }
    
    //MARK:- Events
    
    public func onComplete(_ handler: @escaping (Error?) -> Void) {
        completionHandler = handler
    }
    
    public func onProgress(_ handler: @escaping (Int) -> Void) {
        progressHandler = handler
    }
    
    public func onTimeout(_ handler: @escaping (Error?) -> Void) {
        timeoutHandler = handler
    }

    //MARK:- private utility methods

    private func synchronized(_ obj: AnyObject, closure: () -> Void) {
        objc_sync_enter(obj)
        closure()
        objc_sync_exit(obj)
    }
    
    private func synchronizedTransaction(closure: () throws -> Void) {
        synchronized(self) {
            autoreleasepool {
                let transactionKey = UUID().uuidString
                transactions[transactionKey] = true
                do {
                    try closure()
                } catch {
                    self.gotIOError = true
                }
                transactions.removeValue(forKey: transactionKey)
                lastDataUpdatedAt = Date()
            }
        }
    }
}
