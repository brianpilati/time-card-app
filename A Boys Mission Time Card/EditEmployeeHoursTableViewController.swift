//
//  EditEmployeeHoursTableViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/25/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class EditEmployeeHoursTableViewController: UITableViewController {

    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
    
    func updateStartTime() {
        startTime = startTimeDatePicker.date
    }
    
    func revertStartTime() {
        startTimeDatePicker.date = startTime
    }
    
    func updateEndTime() {
        endTime = endTimeDatePicker.date
    }
    
    func revertEndTime() {
        endTimeDatePicker.date = endTime
    }
    
    func displayErrorAlert() {
        let title = "Time Change Error"
        let message = "The 'End Time' must be greater than the 'Start Time'"
        let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func areDatesValid() -> Bool {
        return startTimeDatePicker.date.compare(endTimeDatePicker.date) == NSComparisonResult.OrderedDescending
    }
    
    func updateTime(isStartTime: Bool) {
        if (self.areDatesValid()) {
            self.revertStartTime()
            self.revertEndTime()
            self.displayErrorAlert()
        } else {
            isStartTime ? self.updateStartTime() : self.updateEndTime()
        }
    }
    
    func revertTime(isStartTime: Bool) {
        isStartTime ? self.revertStartTime() : self.revertEndTime()
    }
    
    func displayAlert(isStartTime: Bool) {
        let title = "Time Change Alert"
        let message = "You are changing payroll hours.\n\nAre you sure?"
        let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alertAction) -> Void in self.updateTime(isStartTime) }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alertAction) -> Void in self.revertTime(isStartTime) }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func startTimeChanged(sender: AnyObject) {
        displayAlert(true)
    }
    
    @IBAction func endTimeChanged(sender: AnyObject) {
        displayAlert(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimeDatePicker.date = startTime
        endTimeDatePicker.date = endTime
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            startTimeDatePicker.becomeFirstResponder()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}