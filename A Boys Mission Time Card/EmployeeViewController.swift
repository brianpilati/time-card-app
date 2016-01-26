//
//  EmployeeViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import CoreData

class EmployeeViewController: UIViewController, UITableViewDelegate,   NSFetchedResultsControllerDelegate, UITableViewDataSource {
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var toolbar: UIToolbar = UIToolbar()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var employee: Employees? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let employee: Employees = self.employee {
            if let label = self.firstNameLabel {
                label.text = employee.firstName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        self.firstNameLabel.frame = CGRectMake(50, 35, screenWidth, 100)
        self.tableView.frame = CGRectMake(0, 100, screenWidth, screenHeight - 300)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EmployeeHoursTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmployeeHoursTableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                abort()
            }
        }
    }
    
    func configureCell(cell: EmployeeHoursTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object: Hours = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Hours
        cell.startTimeLabel?.text = object.startTime?.description
        cell.endTimeLabel?.text = object.endTime?.description
        let endTime: NSDate = object.endTime!
        cell.totalTimeLabel?.text = Int(endTime.timeIntervalSinceDate(object.startTime!)).description
        cell.totalTimeLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 400, 0, 400, cell.bounds.height)
        cell.totalTimeLabel.textAlignment = NSTextAlignment.Center
    }

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Hours", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        fetchRequest.predicate = NSPredicate(format: "employeeId == %d", self.employee!.employeeId)
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
}
