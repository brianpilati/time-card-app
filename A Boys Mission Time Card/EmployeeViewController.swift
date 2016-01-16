//
//  EmployeeViewController.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/13/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        print(self.detailItem)
        if let detail = self.detailItem {
            if let label = self.firstNameLabel {
                label.text = detail.valueForKey("firstName")!.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
