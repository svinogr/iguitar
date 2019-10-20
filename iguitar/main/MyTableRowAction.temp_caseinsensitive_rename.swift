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
    class TableViewRowAction: UITableViewRowAction {
        
        var image: UIImage?
        
        func _setButton(button: UIButton) {
            if let image = image, let titleLabel = button.titleLabel {
                let labelString = NSString(string: titleLabel.text!)
                let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font])
                
                button.tintColor = UIColor.white
                button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                button.imageEdgeInsets.right = -titleSize.width
                
            }
        }
    }
}
