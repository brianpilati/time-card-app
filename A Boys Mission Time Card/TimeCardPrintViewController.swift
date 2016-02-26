//
//  TimeCardPrintViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/26/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class TimeCardPrintViewController: UIViewController {

    @IBOutlet weak var payRangeLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var printingDateLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    
    
    var timeCard: TimeCard? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let timeCard: TimeCard = self.timeCard {
            if let label = self.employeeNameLabel {
                label.text = timeCard.getEmployeeName()
                self.navigationItem.title = "\(timeCard.getEmployeeName())'s Time Card"
            }
            
            if let label = self.printingDateLabel {
                label.text = timeSingleton.getCurrentTime()
            }
            
            if let label = self.payRangeLabel {
                label.text = timeSingleton.getPayRange()
            }
            
            if let label = self.totalHoursLabel {
                label.text = timeCard.getTotalHoursWorkedString()
            }
            
            if let label = self.hourlyRateLabel {
                label.text = "$1.00/Hour"
            }
            
            if let label = self.totalIncomeLabel {
                label.text = Helpers().getWages(timeCard.getTotalHoursWorked())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stylizeNavigationController()
        
        self.configureView()
    }
    
    func stylizeNavigationController() {
        self.navigationItem.setRightBarButtonItems([addPrintButton()], animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
    }
    
    func addPrintButton() -> UIBarButtonItem {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: "printButton:", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, getButtonFrameWidth(), 30)
        button.setImage(UIImage(named: "airprint"), forState: UIControlState.Normal)
        let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.height)! - 10
        
        button.frame = CGRect(x:0, y:0, width:navigationHeight, height:navigationHeight)
        return UIBarButtonItem(customView: button)
    }
    
    func printButton(sender: AnyObject) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "My Print Job"
        printInfo.outputType = .General
        
        // Set up print controller
        let printController = UIPrintInteractionController.sharedPrintController()
        printController.printInfo = printInfo
        
        printController.printingItem = self.view!.toImage()
        
        printController.presentFromRect(self.view.frame, inView: self.view, animated: true, completionHandler: nil)
    }
    
    func getButtonFrameWidth() -> CGFloat {
        return (UIScreen.mainScreen().bounds.width / 8 as CGFloat)
    }
}
