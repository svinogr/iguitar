//
//  myTableRowAction.swift
//  iguitar
//
//  Created by Up Devel on 19/07/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import UIKit

class MyTableRowAction: UITableViewRowAction {

}

extension MyTableRowAction {
    
    func setIcon(iconImage: UIImage, backColor: UIColor, cellHeight: CGFloat, customSwipPartWidth: CGFloat, iconSizePercentage: CGFloat) {
        let iconWidth = customSwipPartWidth * iconSizePercentage
        let iconHeight = iconImage.size.height / iconImage.size.width * iconWidth
        let marginY = (cellHeight - iconHeight) / 2 as CGFloat
        let marginX = (customSwipPartWidth - iconWidth) / 2 as CGFloat
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: customSwipPartWidth, height: cellHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        backColor.setFill()
        context!.fill(CGRect(x:0, y:0, width:customSwipPartWidth, height:cellHeight))
        
        iconImage.draw(in: CGRect(x: marginX, y: marginY, width: iconWidth, height: iconHeight))
        
        let actionImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.backgroundColor = UIColor.init(patternImage: actionImage!)
    }
}
