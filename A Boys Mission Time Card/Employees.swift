//
//  Employees.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation
import CoreData


class Employees: NSManagedObject {
    
    class func createNewEmployee(moc: NSManagedObjectContext, firstName: String, lastName: String, employeeId: Int32) -> Employees {
        let newEmployee = NSEntityDescription.insertNewObjectForEntityForName("Employees", inManagedObjectContext: moc) as! Employees
        newEmployee.firstName = firstName
        newEmployee.lastName = lastName
        newEmployee.employeeId = employeeId
        
        return newEmployee
    }
}
