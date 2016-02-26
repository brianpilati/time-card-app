//
//  Helpers.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/16/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation

class Helpers {
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func getStartOfMonth() -> NSDate {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month], fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    func getEndOfMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let endOfMonth = NSDateComponents()
        endOfMonth.month = 1
        return calendar.dateByAddingComponents(endOfMonth, toDate: self.getStartOfMonth(), options: [])!
    }
}