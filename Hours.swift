//
//  Hours.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/15/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation
import CoreData


class Hours: NSManagedObject {
    class func addNewHours(moc: NSManagedObjectContext, employee: Employee) -> Hours {
        let newHours = NSEntityDescription.insertNewObjectForEntityForName("Hours", inManagedObjectContext: moc) as! Hours
        newHours.employeeId = employee.getEmployeeId()
        newHours.startTime = employee.getStartTime()
        newHours.endTime = employee.getEndTime()
        
        return newHours
    }

}
