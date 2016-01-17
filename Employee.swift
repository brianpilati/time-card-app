//
//  Employee.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/15/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation

class Employee {
    var employeeId: Int32 = 0
    var isEmployeeWorking: Bool = false
    var firstName: String = ""
    var startTime: NSDate!
    var endTime: NSDate!
    
    init() { }
    
    func setEmployeeId(employeeId: Int32) {
        self.employeeId = employeeId
    }
    
    func getEmployeeId() -> Int32 {
        return self.employeeId
    }
    
    func setFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func getFirstName() -> String {
        return self.firstName
    }
    
    func setStartTime() {
        self.startTime = NSDate()
        self.isEmployeeWorking = true
    }
    
    func setStartTime(startTime: NSDate) {
        self.startTime = startTime
        self.isEmployeeWorking = true
    }
    
    func getStartTime() -> NSDate {
        return self.startTime!
    }
    
    func setEndTime() {
        self.endTime = NSDate()
        self.isEmployeeWorking = false
    }
    
    func getEndTime() -> NSDate {
        return self.endTime!
    }
}