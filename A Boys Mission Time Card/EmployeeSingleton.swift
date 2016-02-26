//
//  EmployeeSingleton.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/15/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation

class EmployeeSingleton {
    static let employeeSingleton = EmployeeSingleton()
    
    var currentEmployee: Employee = Employee()
    var employees: [String: NSDate] = [String: NSDate]()
    let dictionaryKey = "Employees"
    
    private init() {
        self.loadDefaults()
    }
    
    func loadDefaults() {
        self.loadEmployees()
        self.loadCurrentUser()
    }
    
    func loadCurrentUser() {
        self.currentEmployee.setEmployeeId(Int32(NSUserDefaults.standardUserDefaults().integerForKey("CurrentUserId")))
        self.currentEmployee.setFirstName(NSUserDefaults.standardUserDefaults().stringForKey("CurrentUserFirstName") ?? "")
        if (isEmployeeWorking()) {
            self.currentEmployee.setStartTime(employees[self.currentEmployee.getEmployeeId().description]!)
        }
    }
    
    func loadEmployees() -> Void {
        if let loadedEmployees = NSUserDefaults().dictionaryForKey(dictionaryKey) as? [String: NSDate] {
            self.employees = loadedEmployees
        }
    }
    
    func getCurrentUserId() -> Int32 {
        return self.currentEmployee.getEmployeeId()
    }
    
    func getCurrentUserFirstName() -> String {
        return self.currentEmployee.getFirstName() ?? ""
    }
    
    func getCurrentEmployee() -> Employee {
        return self.currentEmployee
    }
    
    func updateTime() -> Employee {
        if (isEmployeeWorking()) {
            self.currentEmployee.setEndTime()
            employees.removeValueForKey(self.currentEmployee.getEmployeeId().description)
        } else {
            self.currentEmployee.setStartTime()
            employees[self.currentEmployee.getEmployeeId().description] = self.currentEmployee.getStartTime()
        }
        self.saveEmployees()
        return self.currentEmployee
    }
    
    func isEmployeeWorking() -> Bool {
        return employees[self.currentEmployee.getEmployeeId().description] != nil
    }
    
    func saveEmployees() {
        NSUserDefaults().setObject(employees, forKey: dictionaryKey)
        NSUserDefaults().synchronize()
    }
    
    func setCurrentEmployee(employee : Employees) {
        NSUserDefaults.standardUserDefaults().setValue(employee.employeeId.description, forKey: "CurrentUserId")
        NSUserDefaults.standardUserDefaults().setValue(employee.firstName, forKey: "CurrentUserFirstName")
        NSUserDefaults().synchronize()
        self.loadCurrentUser()
    }
}
let employeeSingleton = EmployeeSingleton()


