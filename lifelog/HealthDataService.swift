//
//  HealthDataService.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/15.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Promises

public class HealthDataService {
    public struct HealthDataServiceError: Error {}
    
    public var watcher: StatusWatcher!
    
    var completionHandler: ((Error?) -> Void)?
    var progressHandler: ((Int) -> Void)?
    var timeoutHandler: ((Error?) -> Void)?
    
    let localDocumentURL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    public var iCloudDocumentURL: URL? {
        return FileManager.default
            .url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent("Documents", isDirectory: true)
    }
    public var documentURL: URL? = nil
    var using_iCloud = false

    var startDate: Date!
    var endDate: Date!
    public var userHealthDB: UserHealthDatabase!
    
    static let instance = HealthDataService()
    private init() { }
    
    public func getHealthData(from startDate: Date, to endDate: Date) {
        prepareDocumentContainer()
        guard let _ = userHealthDB else {
            return
        }
        self.startDate = startDate
        self.endDate = endDate
        print(#file, #line, "HealthDataService.getHealthData: \(startDate) ~ \(endDate)")
        
        if !HKHealthStore.isHealthDataAvailable() {
            watcher.addStatus("⚠️エラー: ヘルスデータを取得できません。")
            watcher.setButtonStatus(enable: true)
            return
        }
        watcher.addStatus("✍️ ヘルスデータを取得開始")
        watcher.setButtonStatus(enable: false)
        
        requestAuthorization().then { healthStore in
            try self.userHealthDB.csvStore.prepareCSVFile(from: startDate, to: endDate)
            return self.saveHealthData(from: healthStore)
        }.catch { error in
            print(#file, #line, "\(Date()): Error: \(error.localizedDescription)")
            self.watcher.addStatus("⚠️エラー: ヘルスデータの取得に失敗しました。")
            self.watcher.setButtonStatus(enable: true)
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
    
    //MARK:- Prepareing Document Container
    
    public func prepareDocumentContainer() {
        if let saveLocation = UserDefaults.standard.string(forKey: UserDefaultKeys.saveLocation) {
            if saveLocation == UserDefaultValues.iClound {
                print(#file, #line, "1 saveLocation = ", saveLocation)
                self.documentURL = iCloudDocumentURL
            } else {
                print(#file, #line, "2 saveLocation = ", saveLocation)
                self.documentURL = localDocumentURL
            }
        } else {
            UserDefaults.standard.set(UserDefaultValues.iClound, forKey: UserDefaultKeys.saveLocation)
            self.documentURL = iCloudDocumentURL
            print(#file, #line, "3 saveLocation = ", UserDefaultKeys.saveLocation)
        }
        let saveLocation = UserDefaults.standard.string(forKey: UserDefaultKeys.saveLocation)!

        // check for documentURL existence
        if let url = self.documentURL, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                
                if saveLocation == UserDefaultValues.iClound {
                    self.watcher.addStatus("🆗 iCloud ドライブに保存場所を用意しました。")
                } else {
                    self.watcher.addStatus("🆗 アプリ内の Documents フォルダに保存場所を用意しました。")
                }
            } catch {
                print(#file, #line, error.localizedDescription)
                self.watcher.addStatus("⚠️エラー: 保存場所を作れません。iPhone の「設定」アプリで iCloud Drive の設定をオンにするか、この画面上部にある「iCloudに保存」をオフにしてください。")
            }
        }
        if let url = self.documentURL {
            self.userHealthDB = UserHealthDatabase(saveTo: url)
            self.userHealthDB.onComplete { error in
                if let handler = self.completionHandler {
                    handler(error)
                }
            }
            self.userHealthDB.onProgress { count in
                if let handler = self.progressHandler {
                  handler(count)
                }
            }
            self.userHealthDB.onTimeout { error in
                if let handler = self.timeoutHandler {
                    handler(error)
                }
            }
        } else {
            self.userHealthDB = nil
        }
    }
    
    //MARK:- Interact with HKHealthStore
    
    private func requestAuthorization() -> Promise<HKHealthStore> {
        return Promise(on: .global()) { (fulfill, reject) in
            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: HealthDataTypes.sampleTypes, read: HealthDataTypes.typesToRead) { (success, error) in
                if success {
                    fulfill(healthStore)
                } else {
                    reject(error ?? HealthDataServiceError())
                }
            }
        }
    }
    
    //MARK:- Retrieving Health Data
    
    private func saveHealthData(from healthStore: HKHealthStore) {
        userHealthDB.startWatcher()
        getCharacteristicData(healthStore)
        getSamples(healthStore)
        getCategoryData(healthStore)
        getActivitySummary(healthStore)
    }
    
    //MARK:- Getting Characcteristic Data
    
    private func getCharacteristicData(_ healthStore: HKHealthStore) {
        var sex = HKBiologicalSex.notSet
        var wheelchairUse = HKWheelchairUse.notSet
        var maybeDateComponents: DateComponents? = nil
        do {
            sex = try healthStore.biologicalSex().biologicalSex
            maybeDateComponents = try healthStore.dateOfBirthComponents()
            let wheelchairUseObject = try healthStore.wheelchairUse()
            wheelchairUse = wheelchairUseObject.wheelchairUse
        } catch {
            print(#file, #line, "\(Date()): Error: some error occured.")
            // ignore error
        }
        
        var sexStr = ""
        switch sex {
        case .female:
            sexStr = "女性"
        case .male:
            sexStr = "男性"
        case .other:
            sexStr = "その他"
        default:
            sexStr = "未設定"
        }
        userHealthDB.setValue(from: startDate, to: endDate, key: "性別", value: sexStr)
        
        var dateOfBirthString = "未設定"
        if let dateComponents = maybeDateComponents {
            let f = DateFormatter()
            f.setTemplate(.date)
            if let dateOfBirth = dateComponents.date {
                dateOfBirthString = f.string(from: dateOfBirth)
            }
        }
        userHealthDB.setValue(from: startDate, to: endDate, key: "誕生日", value: dateOfBirthString)
        
        var wheelchairUseStr = ""
        switch wheelchairUse {
        case .yes:
            wheelchairUseStr = "利用している"
        case .no:
            wheelchairUseStr = "利用していない"
        default:
            wheelchairUseStr = "未設定"
        }
        userHealthDB.setValue(from: startDate, to: endDate, key: "車椅子", value: wheelchairUseStr)
    }
    
    //MARK:- Getting Samples
    
    private func getSamples(_ healthStore: HKHealthStore) {
        HealthDataTypes.sampleKeyAndTypes.keys.forEach() { key in
            let objType = HealthDataTypes.sampleKeyAndTypes[key]!
            getSample(for: key, type: objType, onStore: healthStore)
        }
    }
    
    private func getSample(for key: String, type objType: HKSampleType, onStore healthStore: HKHealthStore) {
        autoreleasepool {
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            let query = HKSampleQuery(sampleType: objType, predicate: predicate,
                                      limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                        (query, mayBeResults, error) in
                                        guard let results = mayBeResults else {
                                            print(#file, #line, "\(Date()): Error: Failed to fetch \(key):  \(error?.localizedDescription ?? "")")
                                            return
                                        }
                                        self.outputSamples(for: key, data: results)
            }
            healthStore.execute(query)
        }
    }
    
    private func outputSamples(for key: String, data samples: [HKSample]) {
        for sample in samples {
            switch sample {
            case let quantitySample as HKQuantitySample:
                userHealthDB.setValue(from: sample.startDate, to: sample.endDate, key: key, value: "\(quantitySample.quantity)")
            case let categorySample as HKCategorySample:
                userHealthDB.setValue(from: sample.startDate, to: sample.endDate, key: key, value: "\(categorySample.value)")
            case let workout as HKWorkout:
                outputWorkout(workout, to: userHealthDB)
            default:
                userHealthDB.setValue(from: sample.startDate, to: sample.endDate, key: key, value: "\(sample)")
            }
        }
    }
    
    private func outputWorkout(_ workout: HKWorkout, to userHealthDB: UserHealthDatabase) {
        userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout duration", value: "\(workout.duration)")
        if let totalDistance = workout.totalDistance {
            userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout totalDistance", value: "\(totalDistance)")
        }
        if let totalEnergyBurned = workout.totalEnergyBurned {
            userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout totalEnergyBurned", value: "\(totalEnergyBurned)")
        }
        let workoutTypeStr : String = HealthDataTypes.workoutTypeDic[workout.workoutActivityType] ?? "other"
        userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout workoutActivityType", value: "\(workoutTypeStr)")
        if let totalFlightsClimbed = workout.totalFlightsClimbed {
            userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout totalFlightsClimbed", value: "\(totalFlightsClimbed)")
        }
        if let totalSwimmingStrokeCount = workout.totalSwimmingStrokeCount {
            userHealthDB.setValue(from: workout.startDate, to: workout.endDate, key: "Workout totalSwimmingStrokeCount", value: "\(totalSwimmingStrokeCount)")
        }
    }
    
    //MARK:- Getting Category Data
    
    private func getCategoryData(_ healthStore: HKHealthStore) {
        HealthDataTypes.categoryKeysAndTypes.keys.forEach() { key in
            let objType = HealthDataTypes.categoryKeysAndTypes[key]!
            getSample(for: key, type: objType, onStore: healthStore)
        }
    }
    
    //MARK:- Getting Activity Summary
    
    private func getActivitySummary(_ healthStore: HKHealthStore) {
        let units = Set<Calendar.Component>([.day, .month, .year, .era])
        
        var startDateComponents = CalendarUtil.calendar.dateComponents(units, from: startDate)
        startDateComponents.calendar = CalendarUtil.calendar
        
        var endDateComponents = CalendarUtil.calendar.dateComponents(units, from: endDate)
        endDateComponents.calendar = CalendarUtil.calendar
        
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents, end: endDateComponents)
        
        let query = HKActivitySummaryQuery(predicate: summariesWithinRange) {
            (query, summaries, error) -> Void in
            guard let activitySummaries = summaries else {
                guard let queryError = error else {
                    print(#file, #line, "\(Date()): Error: Did not return a valid error object.")
                    return
                }
                print(#file, #line, "\(Date()): Error: queryError = \(queryError)")
                return
            }
            for summary in activitySummaries {
                self.outputActivitySummary(summary)
            }
        }
        healthStore.execute(query)
    }
    
    private func outputActivitySummary(_ summary: HKActivitySummary) {
        let date = summary.dateComponents(for: CalendarUtil.calendar).date!
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary activeEnergyBurned",
                              value: "\(summary.activeEnergyBurned)")
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary activeEnergyBurnedGoal",
                              value: "\(summary.activeEnergyBurnedGoal)")
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary appleExerciseTime",
                              value: "\(summary.appleExerciseTime)")
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary appleExerciseTimeGoal",
                              value: "\(summary.appleExerciseTimeGoal)")
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary appleStandHours",
                              value: "\(summary.appleStandHours)")
        userHealthDB.setValue(from: date, to: date,
                              key: "ActivitySummary appleStandHoursGoal",
                              value: "\(summary.appleStandHoursGoal)")
    }
}
