//
//  CsvStoreService.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/10/05.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation
import UIKit

public class CSVStoreService {
    public struct CsvStoreServiceError: Error {}

    let CRLF = "\r\n"
    let BOM = "\u{FEFF}"
    let documentURL: URL!
    var fileURL: URL!
    let deviceId: String!
    let header = ["device id", "start date", "end date", "sample name",  "sample text", "sample value", "unit"]
    
    public init(to documentURL: URL, _ deviceId: String) {
        self.documentURL = documentURL
        self.deviceId = deviceId
    }
    
    public func prepareCSVFile(from startDate: Date, to endDate: Date) throws {
        let savedDateStr = CalendarUtil.dateToString(Date(), template: .forFilename)
        let startDateStr = CalendarUtil.dateToString(startDate, template: .forFilenameShort)
        let endDateStr = CalendarUtil.dateToString(endDate, template: .forFilenameShort)
        self.fileURL = self.documentURL.appendingPathComponent("health_data_\(self.deviceId!)_f\(startDateStr)_t\(endDateStr)_at\(savedDateStr)", isDirectory: false).appendingPathExtension("csv")
        print(#file, #line, "CSVStoreService.store: fileURL = \(self.fileURL!)")
        try BOM.append(to: fileURL)
        try stringArrayToCSVLine(header).append(to: fileURL)
        print("header row = \(header)")
    }
    
    public func outputData(from startDate: Date, to endDate: Date,
                           key sampleKey: String, value: String) throws {
        try autoreleasepool {
            let startDateStr = CalendarUtil.dateToString(startDate, template: .full)
            let endDateStr = CalendarUtil.dateToString(endDate, template: .full)
            
            var row: [String?] = [self.deviceId, startDateStr, endDateStr]
            row.append(sampleKey)
            
            if value.range(of: #"^[^0-9\-\+.]"#, options: .regularExpression) != nil ||
                value.range(of: #"^\d{4}/\d{2}/\d{2}$"#, options: .regularExpression) != nil {
                row.append(value)
                row.append(nil)
                row.append(nil)
            } else {
                row.append(nil)
                row = parseNumericSampleValue(value, row)
            }

            try stringArrayToCSVLine(row).append(to: fileURL)
        }
    }
    
    private func parseNumericSampleValue(_ value: String, _ row: [String?]) -> [String?] {
        var returnValue = row.map { $0 }
        let numericValuePattern = #"^([\-+]?[0-9.]?[0-9.Ee+\-]+) *(.+)?"#
        var regex: NSRegularExpression! = nil
        do {
            regex = try NSRegularExpression(pattern: numericValuePattern, options: [])
        } catch {
            print(#file, #line, "Failed to regexp compile: \(numericValuePattern)")
            return returnValue
        }
        let nsrange = NSRange(value.startIndex..<value.endIndex, in: value)
        regex.enumerateMatches(in: value, options: [], range: nsrange) { (match, _, stop) in
            guard let match = match else { return }
            
            if match.numberOfRanges >= 2,
                let numericCaptureRange = Range(match.range(at: 1), in: value) {
                let numericValue = String(value[numericCaptureRange])
                returnValue.append(numericValue)
                if match.numberOfRanges == 3,
                    let unitCaptureRange = Range(match.range(at: 2), in: value) {
                    let unitValue = String(value[unitCaptureRange])
                    returnValue.append(unitValue)
                }
                stop.pointee = true
            }
        }
        return returnValue
    }
    
    private func stringArrayToCSVLine(_ array: [String?]) -> String {
        autoreleasepool {
            return array.map { maybeCol in
                var colStr = ""
                if let col = maybeCol {
                    colStr =
                        col.replacingOccurrences(of: "\\", with: "\\\\")
                           .replacingOccurrences(of: "\"", with: "\\\"")
                           .replacingOccurrences(of: ",", with: "\\,")
                           .replacingOccurrences(of: "^", with: "\"", options: .regularExpression)
                           .replacingOccurrences(of: "$", with: "\"", options: .regularExpression)
                }
                return colStr
            }.joined(separator: ",") + CRLF
        }
    }
}
