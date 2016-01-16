//
//  Employees+CoreDataProperties.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/15/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Employees {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var image: NSData?
    @NSManaged var employeeId: Int32
}
