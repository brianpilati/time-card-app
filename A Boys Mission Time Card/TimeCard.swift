//
//  TimeCard.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/26/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation

class TimeCard {
    var employeeName: String = ""
    var totalHours: Double = 0
    
    init() { }
    
    
    func setEmployeeName(employeeName: String) {
        self.employeeName = employeeName
    }
    
    func getEmployeeName() -> String {
        return self.employeeName
    }
    
    func setTotalHoursWorked(totalHours: Double) {
        self.totalHours = totalHours
    }
    
    func getTotalHoursWorked() -> Double {
        return self.totalHours
    }
    
    func getTotalHoursWorkedString() -> String {
        return Helpers().timeFormatted(Int(self.getTotalHoursWorked()))
    }
}