//
//  StartHourLabel.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/16/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class StartHourLabel: UILabel {
    
    init() {
        super.init(frame: CGRectZero)
        self.text = ""
        self.textColor = UIColor(red: 38.0/255.0, green: 106.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        self.backgroundColor = UIColor.whiteColor()
        self.textAlignment = .Center
        self.setSizeFont(20)
        self.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var startTime: NSDate? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd h:MM a"
            self.text = dateFormatter.stringFromDate(startTime!)
        }
    }
}
