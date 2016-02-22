//
//  EmployeeHoursTableFooterView.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/27/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class EmployeeHoursTableFooterView: UITableViewCell {
    let totalTimeLabel: UILabel = UILabel()
    let totalTimeDisplayLabel: UILabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(totalTimeLabel)
        contentView.addSubview(totalTimeDisplayLabel)
        
        totalTimeLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/3, 0, UIScreen.mainScreen().bounds.width/3, 50)
        totalTimeLabel.textAlignment = NSTextAlignment.Center
        totalTimeDisplayLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 2 / 3, 0, UIScreen.mainScreen().bounds.width/3, 50)
        totalTimeDisplayLabel.textAlignment = NSTextAlignment.Center
    }

}
