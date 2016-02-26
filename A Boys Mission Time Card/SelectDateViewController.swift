//
//  SelectDateViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/25/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import CoreData

class SelectDateViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    var isStartDate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDate()
        self.setTitle()
        
        self.datePicker.datePickerMode = .Date
    }
    
    func setDate() {
        self.datePicker.date = self.isStartDate ? timeSingleton.getCurrentStartTime() : timeSingleton.getCurrentEndTime()
    }
    
    func setTitle() {
        self.title = self.isStartDate ? "Select Start Date" : "Select End Date"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func datePickerValueChangeAction(sender: AnyObject) {
        if (isStartDate) {
            timeSingleton.setCurrentStartTime(datePicker.date)
        } else {
            timeSingleton.setCurrentEndTime(datePicker.date)
        }
    }
}
