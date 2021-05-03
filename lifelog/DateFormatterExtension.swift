//
//  DateFormatterExtension.swift
//  save-health-data
//
//  imported from https://qiita.com/rinov/items/bff12e9ea1251e895306
//

import Foundation

extension DateFormatter {
    // テンプレートの定義(例)
    public enum Template: String {
        case date = "yMd"     // 2017/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2017/1/1 12:39:22
        case short = "MdkHms" // 2017/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
        case forFilename = "yyyyMMdd-HHmmss"
        case forFilenameShort = "yyyyMMdd"
    }
    
    func setTemplate(_ template: Template, locale localeString: String? = nil) {
        var locale: Locale = .current
        if let concreateLocaleString = localeString {
            locale = Locale(identifier: concreateLocaleString)
        }
        if template == .forFilename {
            locale = Locale(identifier: "en_US_POSIX")
            dateFormat = Template.forFilename.rawValue
        } else if template == .forFilenameShort {
            locale = Locale(identifier: "en_US_POSIX")
            dateFormat = Template.forFilenameShort.rawValue
        } else {
            // optionsは拡張用の引数だが使用されていないため常に0
            dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: locale)
        }
    }
}

