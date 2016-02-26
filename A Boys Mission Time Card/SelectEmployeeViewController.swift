//
//  SelectEmployeeViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit
import CoreData

class SelectEmployeeViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var employeeArray = [Employees]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Employee"
        
        pickerView.delegate = self
        self.loadEmployeesData()
        
        for (index, item) in employeeArray.enumerate() {
            if (item.employeeId == employeeSingleton.getCurrentUserId()) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadEmployeesData() {
        //let fetchRequest = NSFetchRequest(entityName:"Employees")
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Employees", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            employeeArray = try self.managedObjectContext!.executeFetchRequest(fetchRequest) as! [Employees]
        } catch {
            print("caught")
        }
    }
    
    //PICKER VIEW DELEGATE AND DATASOURCE METHODS
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employeeArray.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            let hue = CGFloat(row)/CGFloat(employeeArray.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = employeeArray[row]
        let myTitle = NSAttributedString(string: titleData.firstName!, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employeeSingleton.setCurrentEmployee(employeeArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = employeeArray[row]
        let myTitle = NSAttributedString(string: titleData.firstName!, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
}
