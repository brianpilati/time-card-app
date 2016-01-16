//
//  LabelExtended.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 1/14/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: "Arial", size: sizeFont)!
        self.sizeToFit()
    }
    
    func setBoldSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: "Arial-BoldMt", size: sizeFont)!
        self.sizeToFit()
    }
}