//
//  CalendarUtil.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/18.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation

public enum RelativeMonth: Int {
    case differences = -1
    case thisMonth = 0
    case lastMonth = 1
    case secondMonthAgo = 2
    case thirdMonthAgo = 3
}

public class CalendarUtil {
    public static let calendar = NSCalendar.current
    
    public static func specificMonthSpan(relativeMonth: RelativeMonth, referenceDate: Date? = nil) -> (Date, Date) {
        var relativeMonth = relativeMonth
        var now = referenceDate == nil ? CalendarUtil.now() : referenceDate!
        if (relativeMonth == .differences) {
            if let startDate = UserDefaults.standard.object(forKey: UserDefaultKeys.lastSaved) as? Date {
                return (startDate, now)
            } else {
                relativeMonth = .thirdMonthAgo
            }
        }
        var startDate = CalendarUtil.beginningOfTheMonth(referenceDate: now)
        var endDate = CalendarUtil.endOfTheMonth(referenceDate: now)
        
        for _ in 0 ..< relativeMonth.rawValue {
            now = CalendarUtil.lastMonth(referenceDate: now)
            startDate = CalendarUtil.beginningOfTheMonth(referenceDate: now)
            endDate = CalendarUtil.endOfTheMonth(referenceDate: now)
        }
        return (startDate, endDate)
    }
    
    public static func theDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)!
    }
    
    public static func endOfTheMonth(_ year: Int, _ month: Int) -> Date {
        var components = DateComponents(calendar: calendar, year: year, month: month)
        components.setValue(month + 1, for: .month)
        components.setValue(0, for: .day)
        components.hour = 23
        components.minute = 59
        components.second = 59
        components.nanosecond = 999999
        return calendar.date(from: components)!
    }
    
    public static func endOfTheMonth(referenceDate: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        return CalendarUtil.endOfTheMonth(components.year!, components.month!)
    }
    
    public static func beginningOfTheMonth(referenceDate: Date? = nil) -> Date {
        let now = referenceDate == nil ? CalendarUtil.now() : referenceDate!
        let components = calendar.dateComponents([.year, .month], from: now)
        return calendar.date(from: components)!
    }
        
    public static func now() -> Date {
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: now)
        guard let today = calendar.date(from: components) else {
            fatalError("*** Unable to create now ***")
        }
        return today
    }
    
    public static func beginningOfToday(referenceDate: Date? = nil) -> Date {
        let now = referenceDate == nil ? CalendarUtil.now() : referenceDate!
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        guard let today = calendar.date(from: components) else {
            fatalError("*** Unable to create beginningOfToday ***")
        }
        return today
    }
    
    public static func sevenDaysAgo() -> Date {
        let today = CalendarUtil.now()
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today) else {
            fatalError("*** Unable to create sevenDaysAgo ***")
        }
        return sevenDaysAgo
    }
    
    public static func yesterday(referenceDate: Date? = nil) -> Date {
        let today = referenceDate == nil ? CalendarUtil.now() : referenceDate!
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else {
            fatalError("*** Unable to create yesterday ***")
        }
        return yesterday
    }

    public static func lastMonth(referenceDate: Date? = nil) -> Date {
        let today = referenceDate == nil ? CalendarUtil.now() : referenceDate!
        guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: today) else {
            fatalError("*** Unable to create lastMonth ***")
        }
        return lastMonth
    }

    public static func lastYear() -> Date {
        let today = CalendarUtil.now()
        guard let lastYear = calendar.date(byAdding: .year, value: -1, to: today) else {
            fatalError("*** Unable to create lastYear ***")
        }
        return lastYear
    }
    
    public static func dateToString(_ date: Date?,
                                    template: DateFormatter.Template,
                                    locale: String? = nil) -> String {
        let f = DateFormatter()
        f.setTemplate(template, locale: locale)
        if let concreteDate = date {
            return f.string(from: concreteDate)
        } else {
            return ""
        }
    }
}
