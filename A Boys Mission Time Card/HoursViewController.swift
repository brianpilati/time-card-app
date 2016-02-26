//
//  HoursViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import CoreData



class HoursViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext? = nil
    var hoursButton: UIButton = UIButton()
    let hoursReportDisplayLabel: UILabel = UILabel()
    let wagesReportDisplayLabel: UILabel = UILabel()
    let startTimeDisplayLabel: StartHourLabel = StartHourLabel()
    let endTimeDisplayLabel: EndHourLabel = EndHourLabel()
    var secondsTimer: NSTimer? = nil
    var employee: Employee = Employee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Timer().startWorkingTimer()
        
        self.stylizeNavigationController()
        
        view.backgroundColor = UIColor.whiteColor()
        self.buildLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "\(employeeSingleton.getCurrentUserFirstName())'s Hours"
        self.setHoursButtonTitle()
        self.calculateTotalHoursWorked()
        employee = employeeSingleton.getCurrentEmployee()
        if(employeeSingleton.isEmployeeWorking()) {
            self.startWorkingTimer()
            startTimeDisplayLabel.startTime = employee.getStartTime()
        } else {
            startTimeDisplayLabel.text = ""
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if(employeeSingleton.isEmployeeWorking()) {
            self.stopWorkingTimer()
        }
    }
    
    func buildLayout() {
        self.buildHoursLayout()
        self.buildReportsLayout()
    }
    
    func determineHoursButton() -> String {
        return employeeSingleton.isEmployeeWorking() ? "Stop Working" : "Start Working"
    }
    
    func setHoursButtonTitle() {
        let greenColor: UIColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        let redColor: UIColor = UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 1.0)
        self.hoursButton.setTitle(determineHoursButton(), forState: .Normal)
        self.hoursButton.backgroundColor = employeeSingleton.isEmployeeWorking() ? redColor : greenColor
    }
    
    func addHoursButton() -> UIView {
        let hoursView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, getViewHeight(true)))
        
        self.setHoursButtonTitle()
        self.hoursButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.hoursButton.backgroundColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        self.hoursButton.frame = CGRectMake(15, -50, hoursView.bounds.width/2, hoursView.bounds.height/2)
        self.hoursButton.center = hoursView.center
        self.hoursButton.titleLabel!.font =  UIFont(name: "Arial-BoldMt", size: 40)
        self.hoursButton.layer.borderWidth = 5
        self.hoursButton.layer.borderColor = UIColor.blackColor().CGColor
        self.hoursButton.addTarget(self, action: "hoursButtonPressed:", forControlEvents: .TouchUpInside)
        self.hoursButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        self.hoursButton.layer.cornerRadius = hoursView.bounds.width/25
        
        hoursView.addSubview(hoursButton)
        return hoursView
    }
    
    func calculateCurrentTimeWorked() {
        endTimeDisplayLabel.setTimeWorked((employee.startTime)!)
    }
    
    func calculateTotalHoursWorked() {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Hours", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        fetchRequest.predicate = NSPredicate(format: "employeeId == %d AND startTime >= %@ AND endTime < %@", employeeSingleton.getCurrentUserId(), Helpers().getStartOfMonth(), Helpers().getEndOfMonth())
        
        do {
            var totalHoursWorked: Double = 0.0
            let hoursArray = try self.managedObjectContext!.executeFetchRequest(fetchRequest) as! [Hours]
            for item in hoursArray {
                let endTime: NSDate = item.endTime!
                totalHoursWorked += endTime.timeIntervalSinceDate(item.startTime!)
            }
            hoursReportDisplayLabel.text = Helpers().timeFormatted(Int(totalHoursWorked))
            wagesReportDisplayLabel.text = "\(Helpers().getWages(totalHoursWorked))"
        } catch {
            print("caught")
        }
        
    }
    
    func startWorkingTimer() {
        secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "calculateCurrentTimeWorked", userInfo: nil, repeats: true)
    }
    
    func stopWorkingTimer() {
        secondsTimer?.invalidate()
    }
    
    func hoursButtonPressed(sender: UIButton) {
        let employeeName = employee.getFirstName()
        let title = "\(employeeName), \(self.determineHoursButton())?"
        let message = "You will be logging hours for \(employeeName). Are you sure?"
        let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alertAction) -> Void in self.recordHours(sender) }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func recordHours(sender: UIButton) {
        employee = employeeSingleton.updateTime()
        if (employee.isEmployeeWorking) {
            startTimeDisplayLabel.startTime = employee.startTime
            self.startWorkingTimer()
        } else {
            Hours.addNewHours(self.managedObjectContext!, employee: employee)
            do {
                try self.managedObjectContext!.save()
            } catch {
                abort()
            }
            self.calculateTotalHoursWorked()
            self.stopWorkingTimer()
        }
        self.setHoursButtonTitle()
        
    }
    
    func buildHoursLayout() {
        let hoursView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, getViewHeight(true)))
        hoursView.layer.borderWidth = 1
        hoursView.layer.borderColor = UIColor.blackColor().CGColor
        hoursView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(hoursView)
        
        let reportsCell:UIView = self.addHoursStackView()
        hoursView.addSubview(reportsCell)
        
        reportsCell.frame = hoursView.bounds
        reportsCell.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
    func buildHourLabel(labelText: String) -> UIView {
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.blackColor()
//        label.backgroundColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.setSizeFont(20)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }
    
    func addStartHoursView() -> UIView {
        return self.buildHoursReportStackView([
            self.buildHourLabel("Start Time"), startTimeDisplayLabel,
            self.buildHourLabel("End Time"), endTimeDisplayLabel,
            ])
    }
    
    func buildHoursReportStackView(stackedViews: [UIView]) -> UIView {
        let cell = UIStackView(arrangedSubviews: stackedViews)
        cell.axis = UILayoutConstraintAxis.Horizontal
        cell.distribution = UIStackViewDistribution.FillProportionally
        cell.alignment = UIStackViewAlignment.Fill
        cell.spacing = 1
        cell.layoutMargins = UIEdgeInsets(top: cell.spacing, left: 0, bottom: cell.spacing, right: 0)
        cell.layoutMarginsRelativeArrangement = true
        
        return cell
    }
    
    func addHoursStackView() -> UIView {
        let reportsCell = UIStackView(arrangedSubviews: [self.addHoursButton(), self.addStartHoursView()])
        reportsCell.axis = UILayoutConstraintAxis.Vertical
        reportsCell.distribution = UIStackViewDistribution.Fill
        reportsCell.alignment = UIStackViewAlignment.Fill
        reportsCell.spacing = 5
        reportsCell.layoutMargins = UIEdgeInsets(top: reportsCell.spacing, left: reportsCell.spacing, bottom: reportsCell.spacing, right: reportsCell.spacing)
        reportsCell.layoutMarginsRelativeArrangement = true
        
        return reportsCell
    }
    
    func buildReportsLayout() {
        let reportsView = UIView(frame: CGRectMake(0, getViewHeight(true), UIScreen.mainScreen().bounds.width, getViewHeight(false)))
        reportsView.layer.borderWidth = 1
        reportsView.layer.borderColor = UIColor.blackColor().CGColor
        reportsView.backgroundColor = UIColor.whiteColor()
        view.addSubview(reportsView)
        let reportsCell:UIView = self.addReportStackView()
        reportsView.addSubview(reportsCell)
        
        reportsCell.frame = reportsView.bounds
        reportsCell.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
    func buildReportLabel(labelText: String) -> UIView {
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        label.textAlignment = .Center
        label.setBoldSizeFont(20)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }
    
    func buildReportWagesDisplay(labelText: String) -> UIView {
        wagesReportDisplayLabel.text = labelText
        wagesReportDisplayLabel.textColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        wagesReportDisplayLabel.backgroundColor = UIColor.whiteColor()
        wagesReportDisplayLabel.textAlignment = .Center
        wagesReportDisplayLabel.setSizeFont(60)
        wagesReportDisplayLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        return wagesReportDisplayLabel
    }
    
    func buildReportHoursDisplay(labelText: String) -> UIView {
        hoursReportDisplayLabel.text = labelText
        hoursReportDisplayLabel.textColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        hoursReportDisplayLabel.backgroundColor = UIColor.whiteColor()
        hoursReportDisplayLabel.textAlignment = .Center
        hoursReportDisplayLabel.setSizeFont(60)
        hoursReportDisplayLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        return hoursReportDisplayLabel
    }
    
    func buildReportStackView(stackedViews: [UIView]) -> UIView {
        let cell = UIStackView(arrangedSubviews: stackedViews)
        cell.axis = UILayoutConstraintAxis.Vertical
        cell.distribution = UIStackViewDistribution.FillProportionally
        cell.alignment = UIStackViewAlignment.Fill
        cell.spacing = 1
        cell.layoutMargins = UIEdgeInsets(top: cell.spacing, left: 0, bottom: cell.spacing, right: 0)
        cell.layoutMarginsRelativeArrangement = true
        
        return cell
    }
    
    func addTotalMoneyView() -> UIView {
        return self.buildReportStackView([self.buildReportLabel("Total Wages"), buildReportWagesDisplay("$100")])
    }
    
    func addTotalHoursView() -> UIView {
        return self.buildReportStackView([self.buildReportLabel("Total Hours"), buildReportHoursDisplay("106")])
    }
    
    func addReportStackView() -> UIView {
        let reportsCell = UIStackView(arrangedSubviews: [self.addTotalHoursView(), self.addTotalMoneyView()])
        reportsCell.axis = UILayoutConstraintAxis.Horizontal
        reportsCell.distribution = UIStackViewDistribution.FillEqually
        reportsCell.alignment = UIStackViewAlignment.Fill
        reportsCell.spacing = 5
        reportsCell.layoutMargins = UIEdgeInsets(top: reportsCell.spacing, left: reportsCell.spacing, bottom: reportsCell.spacing, right: reportsCell.spacing)
        reportsCell.layoutMarginsRelativeArrangement = true
        
        return reportsCell
    }
    
    func getViewHeight(isHours: Bool) -> CGFloat {
        let percentage: CGFloat = isHours ? 2/3 : 1/3
        return (UIScreen.mainScreen().bounds.height * percentage as CGFloat)
    }
    
    func segueToEmployees(sender: UIButton) {
        performSegueWithIdentifier("showEmployees", sender: self)
    }
    
    func segueToSelectEmployee(sender: UIButton) {
        performSegueWithIdentifier("showSelectEmployees", sender: self)
    }
    
    func stylizeNavigationController() {
        self.navigationItem.setLeftBarButtonItems([addProfileButton()], animated: true)
        self.navigationItem.setRightBarButtonItems([addEmployeesButton()], animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.blueColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addProfileButton() -> UIBarButtonItem {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.addTarget(self, action: "segueToSelectEmployee:", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, getButtonFrameWidth(), 30)
        button.setImage(UIImage(named: "genericPersonImage.png"), forState: UIControlState.Normal)
        let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.height)! - 10
        
        button.frame = CGRect(x:0, y:0, width:navigationHeight, height:navigationHeight)
        return UIBarButtonItem(customView: button)
    }
    
    func addEmployeesButton() -> UIBarButtonItem {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        //searchBtn.setImage(searchImage, forState: UIControlState.Normal)
        button.addTarget(self, action: "segueToEmployees:", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, getButtonFrameWidth(), 30)
        button.setTitle("Employees", forState: UIControlState.Normal)
        return UIBarButtonItem(customView: button)
    }
    
    func getButtonFrameWidth() -> CGFloat {
        return (UIScreen.mainScreen().bounds.width / 8 as CGFloat)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEmployees" {
            let controller = segue.destinationViewController as! EmployeeTableViewController
            controller.managedObjectContext = self.managedObjectContext
        }
    }
}
