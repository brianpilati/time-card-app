//
//  Timer.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/16/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import UIKit

class Timer: NSNotificationCenter {
    var secondsTimer: NSTimer? = nil
    
    override init() {
        super.init()
    }

    func startWorkingTimer() {
        secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "calculateCurrentTimeWorked", userInfo: nil, repeats: true)
    }
    
    func calculateCurrentTimeWorked() {
        NSNotificationCenter.defaultCenter().postNotificationName(workingTimerNotification, object: self)
    }
    
    func stopWorkingTimer() {
        secondsTimer?.invalidate()
    }
}
