//
//  TimeSingleton.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/25/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation

class TimeSingleton {
    static let timeSingleton = TimeSingleton()
    
    var currentStartTime: NSDate = Helpers().getStartOfMonth()
    var currentEndTime: NSDate = Helpers().getEndOfMonth()
    
    private init() {
        self.loadDefaults()
    }
    
    func loadDefaults() {
        //self.loadEmployees()
        //self.loadCurrentUser()
    }
    
    func getCurrentStartTime() -> NSDate {
        return currentStartTime
    }
    
    func getCurrentEndTime() -> NSDate {
        return currentEndTime
    }
    
    func setCurrentStartTime(date: NSDate) {
        currentStartTime = date
    }
    
    func setCurrentEndTime(date: NSDate) {
        currentEndTime = date
    }
    
    func getFormattedDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeZone = NSTimeZone(name: "GMT")
        return formatter.stringFromDate(date)
    }
    
    func getCurrentStartTimeString() -> String {
        return self.getFormattedDate(self.getCurrentStartTime());
    }
    
    func getCurrentEndTimeString() -> String {
        return self.getFormattedDate(self.getCurrentEndTime());
    }
}
let timeSingleton = TimeSingleton()



