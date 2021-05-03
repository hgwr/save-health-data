//
//  FirstViewController.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/04.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import UIKit
import HealthKit

class FirstViewController: UIViewController, StatusWatcher {
    
    public struct SaveDataError: Error {}

    @IBOutlet weak var saveICloudSwitch: UISwitch!
    @IBOutlet weak var statusHistoryView: UITextView!
    @IBOutlet weak var saveThreeMonthAgoButton: UIButton!
    @IBOutlet weak var saveTwoMonthAgoButton: UIButton!
    @IBOutlet weak var saveLastMonthButton: UIButton!
    @IBOutlet weak var saveThisMonthButton: UIButton!
    @IBOutlet weak var saveDifferencesDataButton: UIButton!
    
    var healthDataService = HealthDataService.instance
    var isHealthDataServicePrepared = false
    var buttonEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let saveLocation = UserDefaults.standard.string(forKey: UserDefaultKeys.saveLocation),
            saveLocation == UserDefaultValues.iClound {
            saveICloudSwitch.isOn = true
        } else {
            saveICloudSwitch.isOn = false
        }
        healthDataService.watcher = self
        prepareHealthDataService()
        prepareHealthDBHooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareHealthDataService()
        prepareHealthDBHooks()
    }
    
    private func prepareHealthDataService() {
        if isHealthDataServicePrepared { return }
        forcePrepareHealthDataService()
        isHealthDataServicePrepared = true
    }
    
    private func forcePrepareHealthDataService() {
        healthDataService.prepareDocumentContainer()
        if healthDataService.userHealthDB == nil {
            self.addStatus("⚠️エラー: データ保存場所を準備できませんでした。 iPhone の「設定」アプリで iCloud Drive の設定をオンにするか、この画面上部にある「iCloudに保存」をオフにしてください。")
            return
        }
    }
    
    private func prepareHealthDBHooks() {
        if healthDataService.userHealthDB == nil { return }
        healthDataService.onComplete { (error) in
            if let concreateError = error {
                print(#file, #line, "Error: ", concreateError.localizedDescription)
                self.addStatus("⚠️エラー: ヘルスデータをファイルに保存することに失敗しました。")
            } else {
                let defaults = UserDefaults.standard
                defaults.set(CalendarUtil.now(), forKey: UserDefaultKeys.lastSaved)
                self.addStatus("🆗 ヘルスデータを保存終了。")
            }
            self.setButtonStatus(enable: true)
        }
        healthDataService.onProgress { count in
            self.addStatus("🏃‍♂️ \(count) 件保存済み...")
        }
        healthDataService.onTimeout { (error) in
            if let concreateError = error {
                print(#file, #line, "Error: ", concreateError.localizedDescription)
            }
            self.addStatus("⚠️エラー: タイムアウト。ヘルスデータを保存に失敗しました。")
            self.setButtonStatus(enable: true)
        }
    }
    
    @IBAction func iCloudSwitchChanged(_ iCloundOnSwitch: UISwitch) {
        if iCloundOnSwitch.isOn {
            print(#file, #line, "1 iCloundOnSwitch.isOn = ", iCloundOnSwitch.isOn)
            UserDefaults.standard.set(UserDefaultValues.iClound, forKey: UserDefaultKeys.saveLocation)
            self.addStatus("ℹ️情報: 保存場所を「iCloud」に変更しました。")
        } else {
            print(#file, #line, "2 iCloundOnSwitch.isOn = ", iCloundOnSwitch.isOn)
            UserDefaults.standard.set(UserDefaultValues.localDirectory, forKey: UserDefaultKeys.saveLocation)
            self.addStatus("ℹ️情報: 保存場所を「ローカル」に変更しました。")
        }
        forcePrepareHealthDataService()
        prepareHealthDBHooks()
    }
    
    @IBAction func saveThreeMotnAgoData(_ sender: UIButton) {
        saveHealthData(relativeMonth: .thirdMonthAgo)
    }
    
    @IBAction func saveTwoMonthAgoData(_ sender: Any) {
        saveHealthData(relativeMonth: .secondMonthAgo)
    }
    
    @IBAction func saveLastMonthData(_ sender: Any) {
        saveHealthData(relativeMonth: .lastMonth)
    }
    
    @IBAction func saveThisMonthData(_ sender: Any) {
        saveHealthData(relativeMonth: .thisMonth)
    }
    
    @IBAction func saveDifferenceData(_ sender: Any) {
        saveHealthData(relativeMonth: .differences)
    }
    
    func saveHealthData(relativeMonth: RelativeMonth) {
        if healthDataService.userHealthDB == nil {
            return
        }
        if buttonEnable {
            let (startDate, endDate) = CalendarUtil.specificMonthSpan(relativeMonth: relativeMonth)
            print(#file, #line, "\(Date()): startDate = \(startDate)")
            print(#file, #line, "\(Date()): endDate = \(endDate)")
            setButtonStatus(enable: false)
            clearExceptLast5Lines()
            healthDataService.getHealthData(from: startDate, to: endDate)
        }
    }
    
    func addStatus(_ text: String? = nil) {
        DispatchQueue.main.async {
            autoreleasepool {
                print(#file, #line, "\(Date()): trace log on addStatus: \(text ?? "")")
                let dateTimeStr = CalendarUtil.dateToString(Date(), template: .short)
                let newHistory: String = dateTimeStr + ": " + (text ?? "") + "\n"
                let historyText = newHistory + (self.statusHistoryView.text ?? "")
                self.statusHistoryView.text = historyText
            }
        }
    }
    
    func clearExceptLast5Lines() {
        DispatchQueue.main.async {
            autoreleasepool {
                var lines = self.statusHistoryView.text.split(separator: "\n").map { line in String(line) }
                lines = lines.prefix(5).map { $0 }
                self.statusHistoryView.text = lines.joined(separator: "\n")
            }
        }
    }
    
    func setButtonStatus(enable: Bool) {
        DispatchQueue.main.async {
            self.buttonEnable = enable
            if enable {
                self.saveICloudSwitch.isEnabled = true
                self.saveThreeMonthAgoButton.isEnabled = true
                self.saveTwoMonthAgoButton.isEnabled = true
                self.saveLastMonthButton.isEnabled = true
                self.saveThisMonthButton.isEnabled = true
                self.saveDifferencesDataButton.isEnabled = true
            } else {
                self.saveICloudSwitch.isEnabled = false
                self.saveThreeMonthAgoButton.isEnabled = false
                self.saveTwoMonthAgoButton.isEnabled = false
                self.saveLastMonthButton.isEnabled = false
                self.saveThisMonthButton.isEnabled = false
                self.saveDifferencesDataButton.isEnabled = false
            }
        }
    }
}
