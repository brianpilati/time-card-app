//
//  UIViewExtended.swift
//  A Boys Mission Time Card
//
//  Created by Brian Pilati on 2/25/16.
//  Copyright © 2016 Brian Pilati. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}