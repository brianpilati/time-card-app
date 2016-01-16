//
//  EmployeeTableTableViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import CoreData

class EmployeeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var toolbar: UIToolbar = UIToolbar()
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Employees"
        //self.addButtons()
    }
    
    func addButtons() {
        self.navigationItem.setRightBarButtonItems([self.editButtonItem()], animated: true)
        
        let checkButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 48)
        toolbar.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.95)
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        toolbar.setItems([flexibleSpace, checkButton], animated: true)
        self.view.addSubview(toolbar)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var frame:CGRect = self.toolbar.frame
        frame.origin.y =  scrollView.contentOffset.y + self.tableView.frame.size.height - self.toolbar.frame.size.height
        self.toolbar.frame = frame
        self.view .bringSubviewToFront(self.toolbar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func insertNewObject(sender: AnyObject) {
        let context = self.fetchedResultsController.managedObjectContext
        Employees.createNewEmployee(context, firstName: "Brian", lastName: "Pilati", employeeId: 1)
        Employees.createNewEmployee(context, firstName: "Ember", lastName: "Pilati", employeeId: 2)
        Employees.createNewEmployee(context, firstName: "Jordan", lastName: "Pilati", employeeId: 3)
        Employees.createNewEmployee(context, firstName: "Drew", lastName: "Pilati", employeeId: 4)
        Employees.createNewEmployee(context, firstName: "Mya", lastName: "Pilati", employeeId: 5)
        Employees.createNewEmployee(context, firstName: "Joshua", lastName: "Pilati", employeeId: 6)
        Employees.createNewEmployee(context, firstName: "Easton", lastName: "Pilati", employeeId: 7)
        
        do {
            try context.save()
        } catch {
            abort()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if (segue.identifier == "showEmployee") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let employee = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = segue.destinationViewController as! EmployeeViewController
                controller.detailItem = employee
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EmployeeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EmployeeTableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    
    func configureCell(cell: EmployeeTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object: Employees = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Employees
        cell.firstNameLabel?.text = object.firstName
        cell.lastNameLabel?.text = object.lastName
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Employees", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! EmployeeTableViewCell, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}