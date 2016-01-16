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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stylizeNavigationController()
        
        view.backgroundColor = UIColor.whiteColor()
        self.buildLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "\(mySingleton.getCurrentUserFirstName()) Hours"
        self.setHoursButtonTitle()
    }
    
    func buildLayout() {
        self.buildHoursLayout()
        self.buildReportsLayout()
    }
    
    func determineHoursButton() -> String {
        return mySingleton.isEmployeeWorking() ? "Stop Working" : "Start Working"
    }
    
    func setHoursButtonTitle() {
        let greenColor: UIColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        let redColor: UIColor = UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 1.0)
        self.hoursButton.setTitle(determineHoursButton(), forState: .Normal)
        self.hoursButton.backgroundColor = mySingleton.isEmployeeWorking() ? redColor : greenColor
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
    
    func hoursButtonPressed(sender: UIButton) {
        let employee: Employee = mySingleton.updateTime()
        if (!employee.isEmployeeWorking) {
            print("update time clock")
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
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        label.textAlignment = .Center
        label.setSizeFont(20)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }
    
    func buildHourDisplay(labelText: String) -> UIView {
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.setSizeFont(20)
        label.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }
    
    func addStartHoursView() -> UIView {
        return self.buildHoursReportStackView([
            self.buildHourLabel("Start Time"), buildHourDisplay("This Morning"),
            self.buildHourLabel("End Time"), buildHourDisplay("This Evening"),
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
    
    func buildReportDisplay(labelText: String) -> UIView {
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.setSizeFont(60)
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        return label
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
        return self.buildReportStackView([self.buildReportLabel("Total Wages"), buildReportDisplay("$100")])
    }
    
    func addTotalHoursView() -> UIView {
        return self.buildReportStackView([self.buildReportLabel("Total Hours"), buildReportDisplay("106")])
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
