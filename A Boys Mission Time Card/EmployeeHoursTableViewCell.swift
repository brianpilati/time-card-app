//
//  EmployeeHoursTableViewCell.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/16/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class EmployeeHoursTableViewCell: UITableViewCell {
    let startTimeLabel: UILabel = UILabel()
    let endTimeLabel: UILabel = UILabel()
    let totalTimeLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(endTimeLabel)
        contentView.addSubview(totalTimeLabel)
        
        startTimeLabel.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/3, 50)
        startTimeLabel.textAlignment = NSTextAlignment.Center
        endTimeLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/3, 0, UIScreen.mainScreen().bounds.width/3, 50)
        endTimeLabel.textAlignment = NSTextAlignment.Center
        totalTimeLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width * 2 / 3, 0, UIScreen.mainScreen().bounds.width/3, 50)
        totalTimeLabel.textAlignment = NSTextAlignment.Center
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}