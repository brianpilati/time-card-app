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
    var totalTimeWorked: Double = 0
    
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
        
        self.firstNameLabel.frame = CGRectMake(50, 35, 200, 100)
        
        self.tableView.frame = CGRectMake(0, 100, screenWidth, screenHeight - 100)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        getResults()
        
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
        cell.startTimeLabel.text = NSDateFormatter.localizedStringFromDate(object.startTime!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        cell.endTimeLabel.text = NSDateFormatter.localizedStringFromDate(object.endTime!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        let endTime: NSDate = object.endTime!
        cell.totalTimeLabel.text = Int(endTime.timeIntervalSinceDate(object.startTime!)).description
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("EmployeeHoursTableHeaderViewCell") as! EmployeeHoursTableViewHeaderView
        headerCell.backgroundColor = UIColor.lightGrayColor()
        headerCell.startTimeLabel.text = "Start Time"
        headerCell.endTimeLabel.text = "End Time"
        headerCell.totalTimeLabel.text = "Total Time Worked"
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("EmployeeHoursTableFooterViewCell") as! EmployeeHoursTableFooterView
        footerCell.backgroundColor = UIColor.lightGrayColor()
        footerCell.totalTimeLabel.text = "Total Time Worked"
        footerCell.totalTimeDisplayLabel.text = Helpers().timeFormatted(Int(totalTimeWorked))
        
        return footerCell
    }
    
    func tableView(tableView: UITableView, heightForCellInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
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
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
    
    func getResults() {
        let fetchRequest = NSFetchRequest(entityName: "Hours")
        fetchRequest.predicate = NSPredicate(format: "employeeId == %d", self.employee!.employeeId)
        
        fetchRequest.resultType = .DictionaryResultType
        
        var expressionDescriptions = [AnyObject]()
        
        // Create an expression description for our SoldCount column
        let expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "timeWorked"
        let endTime = NSExpression(forKeyPath: "endTime")
        let startTime = NSExpression(forKeyPath: "startTime")
        expressionDescription.expression = NSExpression(forFunction: "from:subtract:", arguments:[endTime, startTime])
        expressionDescription.expressionResultType = .DoubleAttributeType
        expressionDescriptions.append(expressionDescription)
        
        fetchRequest.propertiesToFetch = expressionDescriptions
        let sort = NSSortDescriptor(key: "employeeId", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try self.managedObjectContext?.executeFetchRequest(fetchRequest) as NSArray?
            totalTimeWorked = (results as! AnyObject).valueForKeyPath("@sum.timeWorked") as! Double
        } catch {
            print("error")
            abort()
        }
    }
}
