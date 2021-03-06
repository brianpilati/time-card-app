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
    var isStartDate: Bool = true
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
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
                self.navigationItem.title = "\(employee.firstName!)'s Hours"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        self.firstNameLabel.frame = CGRectMake(50, 62, screenWidth / 3 - 50, 50)
        
        self.startDateButton.frame = CGRectMake(screenWidth / 3, 62, screenWidth / 3, 50)
        self.startDateButton.titleLabel!.textAlignment = .Center
        self.startDateButton.addTarget(self, action: "segueToStartDate:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.endDateButton.frame = CGRectMake(screenWidth / 3 * 2, 62, screenWidth / 3, 50)
        self.endDateButton.titleLabel!.textAlignment = .Center
        self.endDateButton.addTarget(self, action: "segueToEndDate:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tableView.frame = CGRectMake(0, 112, screenWidth, screenHeight - 112)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.stylizeNavigationController()
        
        self.configureView()
    }
    
    func stylizeNavigationController() {
        self.navigationItem.setRightBarButtonItems([addPrintButton()], animated: true)
    }
    
    func segueToTimeCardPreview(sender: UIButton) {
        performSegueWithIdentifier("viewPrintPreview", sender: self)
    }
    
    func addPrintButton() -> UIBarButtonItem {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: "segueToTimeCardPreview:", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, getButtonFrameWidth(), 30)
        button.setImage(UIImage(named: "airprint"), forState: UIControlState.Normal)
        let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.height)! - 10
        
        button.frame = CGRect(x:0, y:0, width:navigationHeight, height:navigationHeight)
        return UIBarButtonItem(customView: button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setStartDate()
        self.setEndDate()
        self.getHourTotals()
        self.executeTableRequestFetch()
    }
    
    func setStartDate() {
        self.startDateButton.setTitle("Start Time: \(timeSingleton.getCurrentStartTimeString())", forState: .Normal)
    }
    
    func setEndDate() {
        self.endDateButton.setTitle("End Time: \(timeSingleton.getCurrentEndTimeString())", forState: .Normal)
    }
    
    func segueToStartDate(sender: UIButton) {
        self.isStartDate = true
        performSegueWithIdentifier("showDatePicker", sender: self)
    }
    
    func getButtonFrameWidth() -> CGFloat {
        return (UIScreen.mainScreen().bounds.width / 8 as CGFloat)
    }
    
    func segueToEndDate(sender: UIButton) {
        self.isStartDate = false
        performSegueWithIdentifier("showDatePicker", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "editEmployeeTime") {
            let controller = segue.destinationViewController as! EditEmployeeHoursTableViewController
            let indexPath = tableView.indexPathForSelectedRow
            
            let object: Hours = self.fetchedResultsController.objectAtIndexPath(indexPath!) as! Hours
            controller.startTime = object.startTime!
            controller.endTime = object.endTime!
        
        } else if (segue.identifier! == "viewPrintPreview") {
            let controller = segue.destinationViewController as! TimeCardPrintViewController
            let timeCard: TimeCard = TimeCard()
            timeCard.setEmployeeName((self.employee?.firstName)!)
            timeCard.setTotalHoursWorked(self.totalTimeWorked)
            controller.timeCard = timeCard
        } else {
            let controller = segue.destinationViewController as! SelectDateViewController
            controller.isStartDate = self.isStartDate
        }
    }
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! EditEmployeeHoursTableViewController
        print(detailViewController.endTimeDatePicker.date.description)
        let indexPath = tableView.indexPathForSelectedRow
        
        let object: Hours = self.fetchedResultsController.objectAtIndexPath(indexPath!) as! Hours
        object.startTime = detailViewController.startTimeDatePicker.date
        object.endTime = detailViewController.endTimeDatePicker.date
        
        do {
            try self.fetchedResultsController.managedObjectContext.save()
        } catch {
            abort()
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EmployeeHoursTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmployeeHoursTableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: EmployeeHoursTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object: Hours = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Hours
        cell.startTimeLabel.text = NSDateFormatter.localizedStringFromDate(object.startTime!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        cell.endTimeLabel.text = NSDateFormatter.localizedStringFromDate(object.endTime!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let endTime: NSDate = object.endTime!
        cell.totalTimeLabel.text = Helpers().timeFormatted(Int(endTime.timeIntervalSinceDate(object.startTime!)))
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
        footerCell.totalTimeDisplayLabel.text = Helpers().timeFormatted(Int(self.totalTimeWorked))
        
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
    
    func buildFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Hours", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchRequestPredicate() -> NSPredicate {
        return NSPredicate(format: "employeeId == %d AND startTime >= %@ AND endTime < %@", self.employee!.employeeId, timeSingleton.getCurrentStartTime(), timeSingleton.getCurrentEndTime())
    }
    
    func executeTableRequestFetch() {
        do {
            self.fetchedResultsController.fetchRequest.predicate = getFetchRequestPredicate()
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: buildFetchRequest(), managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        executeTableRequestFetch()
        
        return _fetchedResultsController!
    }
    
    func getHourTotals() {
        let fetchRequest = NSFetchRequest(entityName: "Hours")
        
        fetchRequest.predicate = NSPredicate(format: "employeeId == %d AND startTime >= %@ AND endTime < %@", self.employee!.employeeId, timeSingleton.getCurrentStartTime(), timeSingleton.getCurrentEndTime())
        
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
            self.totalTimeWorked = (results as! AnyObject).valueForKeyPath("@sum.timeWorked") as! Double
        } catch {
            print("error")
            abort()
        }
    }
}
