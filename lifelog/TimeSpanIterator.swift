//
//  TimeSpanIterator.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/08.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import Foundation

public class TimeSpanIterator {
    open var calendar: Calendar
    open var startDate: Date
    open var endDate: Date
    open var stepType: Calendar.Component
    open var step: Int
    
    
    public init(_ calendar: Calendar,
                from startDate: Date, to endDate: Date,
                byStepping component: Calendar.Component, value: Int) {
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
        self.stepType = component
        self.step = value
    }
    
    public func iterate(iteratedBlock: @escaping (_ startDate: Date, _ endDate: Date) -> Void) {
        var currentStartDate = self.startDate
        var currentEndDate =
            self.calendar.date(byAdding: self.stepType, value: self.step, to: currentStartDate)
        
        while (currentEndDate! <= self.endDate) {
            iteratedBlock(currentStartDate, currentEndDate!)
            currentStartDate = currentEndDate!
            currentEndDate =
                self.calendar.date(byAdding: self.stepType, value: self.step, to: currentStartDate)
        }
    }
}
